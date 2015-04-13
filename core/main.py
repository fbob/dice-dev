# Standard Python modules
# =======================
import os
from importlib import import_module
from concurrent.futures import ThreadPoolExecutor

# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, qDebug, QCoreApplication, QTimer, Qt
from PyQt5.QtQml import qmlRegisterType, QQmlApplicationEngine, QQmlContext
from PyQt5.QtQuick import QQuickItem, QQuickWindow

# DICE modules
# ============
from core.project import Project
from core.dice.tools.json_sync import JsonOrderedDict, JsonList

from core.theme import Theme
from core.tools.memory_info import MemoryInfo
from core.tools.error_handler import ErrorHandler

from core.dice.core_app import CoreApp, CoreAppListModel
from core.app import BasicApp
from core.dice.vis.basic_wrapper import BasicWrapper
from core.dice.vis.camera import Camera


class Dice(QObject):
    def __init__(self, parent=None):
        super(Dice, self).__init__(parent)

        self.application_dir = QCoreApplication.applicationDirPath()

        self.__project = Project(self)  # used as an empty default project, replaced by load_project()
        self.__desk = None
        self.__settings = None
        self.__home = None
        qmlRegisterType(Project, "DICE", 1, 0, "Project")

        self.__theme = Theme(self)
        self.__memory = MemoryInfo(self)
        self.__error = ErrorHandler(self)
        qmlRegisterType(MemoryInfo, "DICE", 1, 0, "MemoryInfo")
        qmlRegisterType(ErrorHandler, "DICE", 1, 0, "ErrorHandler")
        qmlRegisterType(BasicWrapper, "DICE", 1, 0, "BasicWrapper")
        qmlRegisterType(Camera, "DICE", 1, 0, "Camera")

        self.__app_log_buffer = {}
        self.__app_log_write_interval = 500
        self.__app_log_writer = self.__init_log_writer()

        self.__qml_engine = None
        self.__qml_context = None
        self.__app_window = None
        self.__main_window = None

        self.__core_apps = CoreAppListModel(self)

        qmlRegisterType(CoreApp, "DICE", 1, 0, "CoreApp")
        qmlRegisterType(BasicApp, "DICE", 1, 0, "BasicApp")

        self.executor = ThreadPoolExecutor(max_workers=2)  # TODO: set the max_workers from a configuration

        self.core_app_loaded.connect(self.__insert_core_app, Qt.QueuedConnection)
        self.__app_candidates = None
        self.__current_loading_core_app_index = 0
        self.__load_next_core_app()  # load the first core app in this thread, but the other in the executor

    core_app_loaded = pyqtSignal(CoreApp)

    def __insert_core_app(self, core_app):
            self.__core_apps.append(core_app)
            self.core_apps_changed.emit()

    def __continue_loading_apps(self):
        self.executor.submit(self.__load_next_core_app)

    def __load_next_core_app(self):
        if self.__app_candidates is None:
            core_apps_json = os.path.join(self.application_dir, "core_apps", "core_apps.json")
            self.__app_candidates = JsonList(core_apps_json)

        if self.__current_loading_core_app_index == len(self.__app_candidates):
            return

        core_app_name = self.__app_candidates[self.__current_loading_core_app_index]
        qDebug("load "+core_app_name)
        self.__current_loading_core_app_index += 1
        core_app = self.__create_core_app(core_app_name)

        if core_app is not None:
            core_app.load()
            core_app.completed.connect(self.__continue_loading_apps)
            self.core_app_loaded.emit(core_app)

            # set really special core apps
            if core_app.name == "Home":
                self.home = core_app
            elif core_app.name == "Desk":
                self.desk = core_app
            elif core_app.name == "Settings":
                self.settings = core_app
        else:
            raise Exception("Could not load "+core_app_name)

    def __create_core_app(self, core_app_name):
        """
        Creates a core app by its name and returns it.
        :param core_app_name:
        :return: CoreApp
        """
        if os.path.exists(os.path.join(self.application_dir, "core_apps", core_app_name, "core_app.py")):
            module_name = ".".join(["core_apps", core_app_name, "core_app"])
            module = import_module(module_name)
            class_object = getattr(module, core_app_name)

            core_app = class_object()
            core_app.moveToThread(self.thread())
            core_app.setParent(self)
            return core_app
        else:
            return None

    @pyqtSlot(str, name="loadProject")
    def load_project(self, json_file):
        qDebug("load project "+json_file)
        if not os.path.exists(json_file):
            raise Exception("project.dice not found in "+str(json_file))

        project = Project(self)
        project.path = os.path.abspath(os.path.dirname(json_file))
        project.project_config = JsonOrderedDict(json_file)

        if "projectName" in project.project_config:
            project.name = project.project_config["projectName"]

        self.project = project  # set project before using self.desk, so it can access the project
        self.desk.load_desk(project.project_config)
        project.loaded = True
        self.home.add_recent_project(project.name, json_file)

    @pyqtSlot(str, str, str, name="createNewProject")
    def create_new_project(self, name, path, description):
        name = name.strip()
        if name == "":
            raise Exception("project", "no name given")

        # create folders
        project_path = os.path.join(path, name)
        if os.path.exists(project_path):
            raise Exception("project", "directory already exists")

        if not os.access(path, os.W_OK):
            raise Exception("project", "directory is not writable")

        os.mkdir(project_path)

        # create project.dice
        project_dice = os.path.join(project_path, "project.dice")
        pd = JsonOrderedDict(project_dice)
        conf = {"projectName": name, "apps": [], "groups": [], "connections": [], "description": description}
        pd.update(conf)

        self.load_project(project_dice)

    core_apps_changed = pyqtSignal(name="coreAppsChanged")

    @property
    def core_apps(self):
        return self.__core_apps

    coreApps = pyqtProperty(CoreAppListModel, fget=core_apps.fget, notify=core_apps_changed)

    project_changed = pyqtSignal(name="projectChanged")

    @pyqtProperty(Project, notify=project_changed)
    def project(self):
        return self.__project

    @project.setter
    def project(self, project):
        if self.__project != project:
            if self.__project is not None:
                self.__project.close()
            self.__project = project
            self.project_changed.emit()

    desk_changed = pyqtSignal(name="deskChanged")

    @pyqtProperty(CoreApp, notify=desk_changed)
    def desk(self):
        return self.__desk

    @desk.setter
    def desk(self, desk):
        if self.__desk != desk:
            self.__desk = desk
            self.desk_changed.emit()

    settings_changed = pyqtSignal(name="settingsChanged")

    @pyqtProperty(CoreApp, notify=settings_changed)
    def settings(self):
        return self.__settings

    @settings.setter
    def settings(self, settings):
        if self.__settings != settings:
            self.__settings = settings
            self.settings_changed.emit()

    home_changed = pyqtSignal(name="homeChanged")

    @pyqtProperty(CoreApp, notify=home_changed)
    def home(self):
        return self.__home

    @home.setter
    def home(self, home):
        if self.__home != home:
            self.__home = home
            self.home_changed.emit()

    theme_changed = pyqtSignal(name="themeChanged")

    @pyqtProperty(QObject, notify=theme_changed)
    def theme(self):
        return self.__theme

    @theme.setter
    def theme(self, theme):
        if self.__theme != theme:
            self.__theme = theme
            self.theme_changed.emit()

    app_window_changed = pyqtSignal(name="appWindowChanged")

    @property
    def app_window(self):
        return self.__app_window

    @app_window.setter
    def app_window(self, app_window):
        if self.__app_window != app_window:
            self.__app_window = app_window
            self.app_window_changed.emit()

    appWindow = pyqtProperty(QQuickWindow, fget=app_window.fget, fset=app_window.fset, notify=app_window_changed)

    main_window_changed = pyqtSignal(name="mainWindowChanged")

    @property
    def main_window(self):
        return self.__main_window

    @main_window.setter
    def main_window(self, main_window):
        if self.__main_window != main_window:
            self.__main_window = main_window
            self.main_window_changed.emit()

    mainWindow = pyqtProperty(QQuickItem, fget=main_window.fget, fset=main_window.fset, notify=main_window_changed)

    qml_engine_changed = pyqtSignal(name="qmlEngineChanged")

    @property
    def qml_engine(self):
        return self.__qml_engine

    @qml_engine.setter
    def qml_engine(self, qml_engine):
        if self.__qml_engine != qml_engine:
            self.__qml_engine = qml_engine
            self.qml_engine_changed.emit()

    qmlEngine = pyqtProperty(QQmlApplicationEngine, fget=qml_engine.fget, fset=qml_engine.fset,
                             notify=qml_engine_changed)

    qml_context_changed = pyqtSignal(name="qmlContextChanged")

    @property
    def qml_context(self):
        return self.__qml_context

    @qml_context.setter
    def qml_context(self, qml_context):
        if self.__qml_context != qml_context:
            self.__qml_context = qml_context
            self.qml_context_changed.emit()

    qmlContext = pyqtProperty(QQmlContext, fget=qml_context.fget, fset=qml_context.fset, notify=qml_context_changed)

    memory_changed = pyqtSignal(name="memoryChanged")

    @pyqtProperty(MemoryInfo, notify=memory_changed)
    def memory(self):
        return self.__memory

    error_changed = pyqtSignal(name="errorChanged")

    @pyqtProperty(ErrorHandler, notify=error_changed)
    def error(self):
        return self.__error

    def process_exception(self, exc):
        qDebug("process exception "+str(exc))
        self.error.type = exc.__class__.__name__
        self.error.msg = "\n".join(exc.args)
        self.error.occurred.emit()

    def alert(self, msg):
        self.error.type = "alert"
        self.error.msg = str(msg)
        self.error.occurred.emit()

    new_log = pyqtSignal(BasicApp, str, name="newLog", arguments=["app", "log"])

    def app_log(self, app, log):
        try:
            self.__app_log_buffer[app].append(str(log))
        except KeyError:
            self.__app_log_buffer[app] = []
            self.__app_log_buffer[app].append(str(log))

    def __write_app_log(self):
        for app in self.__app_log_buffer:
            log = self.__app_log_buffer[app]
            if log:
                self.__app_log_buffer[app] = []
                self.new_log.emit(app, ''.join(log))

    def __init_log_writer(self):
        timer = QTimer()
        timer.setSingleShot(False)
        timer.setInterval(self.__app_log_write_interval)
        timer.timeout.connect(self.__write_app_log)
        timer.start()
        return timer
