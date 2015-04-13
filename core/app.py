# Standard Python modules
# =======================
import os
import sys
import queue
import subprocess
import warnings
from tempfile import gettempdir
from threading import Thread

# External modules
# ================
from PyQt5.QtCore import QObject, qDebug, pyqtSignal, pyqtSlot, pyqtProperty, QVariant, QThread, Qt
from PyQt5.QtQml import QJSValue

# DICE modules
# ============
from core.dice.tools.json_sync import JsonList, JsonOrderedDict
from core.tools.pyqt import convert_object_to_qjsvalue
from core.app_helper.file_operations import FileOperations
from core.app_helper.qml_helper import QMLHelper
from core.app_helper.process_runner import ProcessRunner
from core.app_helper.dict_helper import DictHelper
from core.dice.vis.vis_app import VisApp


class AppWorker(Thread):
    def __init__(self, app):
        Thread.__init__(self, daemon=True)
        self.queue = queue.Queue()
        self.app = app

    def run(self):
        # from time import sleep
        # sleep(8)
        # self.app.vo[0].min_x = 1
        while True:
            work = self.queue.get()
            try:
                method = getattr(self.app, work[0])
                result = method(*work[1])
                if work[2] is not None:
                    self.app.call_finished.emit(result, work[2])
            except BaseException as e:  # anything might happen here
                qDebug("Exception executing "+str(work[0]))
                import traceback
                qDebug(traceback.format_exc())
                self.app.dice.process_exception(e)


class BasicApp(QObject, QMLHelper, VisApp, ProcessRunner, FileOperations, DictHelper):
    app_name = "NoNameApp"

    output_types = []
    input_types = []
    RUN_FOLDER = "run"

    min_input_apps = 0
    max_input_apps = float("inf")

    IDLE = "idle"  # first state when the app is put on the desk
    PREPARING = "preparing"  # while prepare() is running
    PREPARED = "prepared"  # when prepare() is successfully finished
    WAITING = "waiting"  # while waiting for other apps to finish
    RUNNING = "running"  # while run() is running
    PAUSED = "paused"  # when a running app is paused
    ERROR = "error"  # when run() or prepare() returned unsuccessfully
    FINISHED = "finished"  # when run() returned successfully

    def __init__(self, parent, instance_name, status):
        QObject.__init__(self, parent)
        QMLHelper.__init__(self)
        VisApp.__init__(self)

        self.__instance_name = instance_name
        self.__status = status

        self.__callbacks = {}

        self.__tmp_path = None

        self.__input_apps = []
        self.__output_apps = []

        self.config = None

        self.__in_loop = False
        self.__iteration = 1

        self.__worker = AppWorker(self)
        self.__worker.start()

        self.running_procs = []

    def setParent(self, core_app):
        """
        Override setParent of QObject as some methods can only be called when the parent, i.e. the desk, is set.
        :param core_app:
        :return:
        """
        super().setParent(core_app)
        self.__create_app_directory()
        self.config = self.__prepare_config()

    def load(self):
        """
        Called after the app is initialized.
        Only after this method is called, config_path() and other properties which depend on the dice property
        are ready to be used.
        """
        pass

    def load_internal(self):
        """
        Called before load(). Do not override this method, as it is needed by the app system.
        This is an internal method, not intended for other uses.

        All connections needed by the BasicApp need to be created here, so they are in the QML thread.
        """
        QMLHelper.load_internal(self)
        self.instance_name_changed.connect(self.on_instance_name_changed)
        self.status_changed.connect(self.on_status_changed)
        self.input_apps_changed.connect(self.on_input_apps_changed)
        self.call_finished.connect(self.process_finished_call, type=Qt.QueuedConnection)

    @property
    def project(self):
        return self.dice.project

    @property
    def desk(self):
        return self.dice.desk

    @property
    def dice(self):
        return self.parent().dice  # the app is always created by a CoreApp (actually Desk)

    name_changed = pyqtSignal(name="nameChanged")

    @pyqtProperty("QString", notify=name_changed)
    def name(self):
        return self.app_name

    instance_name_changed = pyqtSignal(name="instanceNameChanged")

    @property
    def instance_name(self):
        return self.__instance_name

    @instance_name.setter
    def instance_name(self, instance_name):
        if self.__instance_name != instance_name:
            self.__instance_name = instance_name
            self.instance_name_changed.emit()

    instanceName = pyqtProperty(str, fget=instance_name.fget, fset=instance_name.fset, notify=instance_name_changed)

    def on_instance_name_changed(self):
        """
        This method is called when the instance name of the app is changed, e.g. by renaming the app.
        By default it calls self.load() which should reload all instance variables that depend on the config_path()
        """
        self.load()

    @pyqtSlot(str, name="renameInstanceName", result=bool)
    def rename_instance_name(self, new_instance_name):
        if new_instance_name == self.instance_name:
            return False
        project_path = self.project.path
        new_folder_path = os.path.join(project_path, "config", new_instance_name)
        if os.path.isdir(new_folder_path):
            return False
        else:
            os.rename(self.config_path(), new_folder_path)
            self.config.file_name = os.path.join(new_folder_path, "app.dice")
            if os.path.exists(self.current_run_path()):
                gp = self.project.path
                iteration = self.current_iteration() if self.is_in_loop() else ''
                new_run_path = os.path.join(gp, self.RUN_FOLDER, iteration, new_instance_name)
                os.rename(self.current_run_path(), new_run_path)
            self.desk.rename_app(self.instance_name, new_instance_name)
            self.instance_name = new_instance_name
            return True

    def package_name(self):
        return ".".join(self.__module__.split(".")[:-1])

    input_types_model_changed = pyqtSignal(name="inputTypesChanged")

    @pyqtProperty("QVariantList", notify=input_types_model_changed)
    def input_types_model(self):
        return [{'input_type': it} for it in self.input_types]

    output_types_model_changed = pyqtSignal(name="outputTypesChanged")

    @pyqtProperty("QVariantList", notify=output_types_model_changed)
    def output_types_model(self):
        return [{'output_type': ot} for ot in self.output_types]

    def appPath(self, *subPaths):
        warnings.warn("use config_path", DeprecationWarning)
        return self.config_path(*subPaths)

    @pyqtSlot(name="configPath", result=str)
    @pyqtSlot("QStringList", name="configPath", result=str)
    def config_path(self, *sub_paths):
        return os.path.join(self.project.path, "config", self.instance_name, *sub_paths)

    def __create_app_directory(self):
        self.make_dir(self.config_path())

    status_changed = pyqtSignal(name="statusChanged")

    @pyqtProperty("QString", notify=status_changed)
    def status(self):
        return self.__status

    @status.setter
    def status(self, status):
        if self.__status != status:
            self.__status = status
            self.status_changed.emit()
            self.write_conf()

    def on_status_changed(self):
        pass

    def module_path(self):
        # doesn't work as a property, we need it during construction
        return os.path.abspath(os.path.join(*self.__module__.split(".")[:-1]))

    def callback(self, name, arguments=[]):
        warnings.warn("use signal", DeprecationWarning)
        self.signal(name, arguments)

    def signal(self, name, *arguments):
        """
        Sends a signal with the given name and arguments.
        :param name: name of the signal
        :param arguments: arguments for the signal
        :return:
        """
        if name in self.__callbacks:
            for cb in self.__callbacks[name]:
                try:
                    cb(*arguments)
                except Exception as ex:
                    self.debug(str(ex))
        if name in self._qml_callbacks:
            self.qml_signal.emit(name, arguments)  # don't call the signal directly but through a queued connection

    def connect(self, name, function):
        """
        Connects a signal name with a function.
        :param name: name of the signal
        :param function: a callable function
        :return:
        """
        if name not in self.__callbacks:
            self.__callbacks[name] = []
        if function not in self.__callbacks[name]:
            # self.debug("connect "+name+ " to "+str(function))
            self.__callbacks[name].append(function)

    def disconnect(self, name, function):
        try:
            self.__callbacks[name].remove(function)
        except:
            self.debug("could not disconnect from "+str(name)+"@"+str(function))

    def log(self, msg):
        self.dice.app_log(self, msg)

    def alert(self, msg):
        self.dice.alert(str(msg))

    @staticmethod
    def debug(msg):
        qDebug(str(msg))

    def delivers(self, output):
        """
        Returns true if the app has the desired output in output_types.
        :param output:
        :return:
        """
        return output in self.output_types

    def get_model_data(self, path=None, *args):
        """
        Returns the model as stored in the DB.
        The DB could be stored in the users config folder, the app installation folder or the global DICE db folder.
        The path is then searched in this order in all these folders.
        :param path:
        :param args:
        :return:
        """
        if path is None:
            return []

        file_path, dict_path = self.split_path(path)

        file_name = os.path.join(self.module_path(), "db", file_path)+".json"
        # TODO: merge lists if local and global files exist
        if not os.path.exists(file_name):
            file_name = os.path.join(self.dice.application_dir, "db", file_path)+".json"
            if not os.path.exists(file_name):
                return []

        if dict_path:
            jl = JsonOrderedDict(file_name)
            return self.get_value_by_path(jl, dict_path)
        else:
            jl = JsonList(file_name)
            return jl

    def model_data_signal_name(self, path=None, *args):
        return None

    def temp_path(self, *sub_paths):
        if self.__tmp_path is None:
            self.__tmp_path = os.path.join(gettempdir(), self.instance_name)
        return os.path.join(self.__tmp_path, *sub_paths)

    def clean_temp_path(self):
        if self.__tmp_path is not None:
            self.rmtree(self.__tmp_path)

    def copy_template_folder(self):
        template_path = os.path.join(self.module_path(), "template/")
        if os.path.exists(template_path):
            self.copy_folder_content(template_path, self.config_path())

    @staticmethod
    def __types_overlap(my, other):
        """
        Checks if the lists "my" and "other" have overlapping items
        :param my: inputTypes of the current app
        :param other: outputTypes of the other app
        :return:
        """
        intersection = [item for item in my if item in other]
        return len(intersection) > 0

    def accepts_input_app(self, other):
        """
        Checks if an app is allowed to be an input for the current app.
        By default is checks if the current apps inputTypes overlap with the other apps outputTypes
        :param app:
        :return:
        """
        # TODO: check max_input_apps
        return self.__types_overlap(self.input_types, other.output_types)

    def delete_instance(self):
        self.rmtree(self.config_path())
        return True

    def write_conf(self):
        common = {
            "package": self.package_name(),
            "instanceName": self.instance_name,
            "x": self._x,
            "y": self._y,
            "status": self.status
        }
        if "General" not in self.config:
            self.config["General"] = {}
        self.config["General"].update(common)
        self.config.write()
        self.signal("app.dice")

    def __copy_init_conf_file(self):
        init_conf_file_path = os.path.join(self.module_path(), "app.dice")
        try:
            self.copy(init_conf_file_path, self.config_path())
        except FileNotFoundError:
            self.debug("app.dice not found in "+init_conf_file_path)

    def __prepare_config(self):
        conf = self.config_path("app.dice")
        if not os.path.exists(conf):
            self.__copy_init_conf_file()
            self.config = JsonOrderedDict(conf)
            self.write_conf()
        else:
            self.config = JsonOrderedDict(conf)
        self.desk.add_app(self.instance_name)
        return self.config

    def get_app_config(self, path):
        self.debug("get config: "+str(path))
        var_path = path.split(" ")
        try:
            return self.get_value_by_path(self.config, var_path)
        except KeyError:
            return None

    def set_app_config(self, path, value):
        self.debug("set config "+str(path)+ " "+str(value))
        var_path = path.split(" ")
        dict_var = self.get_dict_by_path(self.config, var_path)
        dict_var[var_path[-1]] = value
        self.config.write()
        self.signal(self.app_config_signal_name())

    def app_config_signal_name(self, *path):
        return "app.dice"

    input_apps_changed = pyqtSignal(name="inputAppsChanged")

    @property
    def input_apps(self):
        return self.__input_apps

    inputApps = pyqtProperty("QVariantList", fget=input_apps.fget, notify=input_apps_changed)

    def add_input_app(self, app):
        if app not in self.__input_apps:
            self.__input_apps.append(app)
            self.__connect_with_input_apps()
            self.input_apps_changed.emit()

    def remove_input_app(self, app):
        if app in self.__input_apps:
            self.__input_apps.remove(app)
            self.__connect_with_input_apps()
            self.input_apps_changed.emit()

    def __connect_with_input_apps(self):
        """
        Goes through all input apps and connects their outputs if it matches the input_types of this app.
        """
        inputs = {name: {} for name in self.input_types}  # dict of empty lists for each input type
        for input_app in self.__input_apps:
            for in_type in self.input_types:
                if in_type in input_app.output_types:
                    try:
                        output_data = getattr(input_app, in_type+"_out")
                        inputs[in_type][input_app] = output_data()
                    except AttributeError:
                        pass
                    changed_signal = getattr(input_app, in_type+"_out_changed", None)
                    if changed_signal is not None:
                        # TODO: connect with a function that only processes the specific type
                        # for now we re-process all input apps on each change
                        try:
                            changed_signal.disconnect(self.__connect_with_input_apps)  # disconnect first to prevent multiple calls
                        except:
                            pass
                        changed_signal.connect(self.__connect_with_input_apps)

        for in_type in self.input_types:
            # always set the value, even if it's empty
            try:
                setter = getattr(self, in_type+"_in")
            except AttributeError:
                continue
            setter(inputs[in_type])

    def on_input_apps_changed(self):
        """
        This slot is called from PythonApp whenever the input apps are changed.
        Override in your apps to implement some sensible logic.
        :param input_apps:
        :return:
        """
        pass

    output_apps_changed = pyqtSignal(name="outputAppsChanged")

    @property
    def output_apps(self):
        return self.__output_apps

    outputApps = pyqtProperty("QVariantList", fget=output_apps.fget, notify=output_apps_changed)

    def add_output_app(self, app):
        self.__output_apps.append(app)
        self.output_apps_changed.emit()

    def remove_output_app(self, app):
        for ia in self.__output_apps:
            if ia == app:
                self.__output_apps.remove(ia)
                self.output_apps_changed.emit()
                return

    def is_in_loop(self):
        # TODO: check if the app is in a loop
        return self.__in_loop

    def current_iteration(self):
        return self.__iteration

    def current_iteration_path(self, *path):
        gp = self.project.path
        iteration = self.current_iteration() if self.is_in_loop() else ''
        return os.path.join(gp, self.RUN_FOLDER, iteration, self.instance_name, *path)

    @pyqtSlot(name="currentRunPath", result=str)
    @pyqtSlot("QStringList", name="currentRunPath", result=str)
    def current_run_path(self, *path):
        return self.current_iteration_path(*path)

    def create_run_directory(self, overwrite=True):
        cip = self.current_iteration_path()
        if overwrite and os.path.exists(cip):
            self.rmtree(cip)
        self.make_dir(cip)

    def prepare(self):
        """
        Prepare an app instance for running.
        This will usually involve copying files from the config folder into the run folder.
        This method does nothing by default and should be overridden if needed.
        :return:
        """
        return True  # do nothing by default and allow to start run()

    def run(self):
        """
        This method is called to do the actual work of an app instance.
        Returning True will set the status to FINISHED, returning False will set it to ERROR
        :return:
        """
        return False

    def open_config_folder(self):
        folder = self.config_path()
        if sys.platform.startswith('linux'):
            subprocess.call(["xdg-open", folder])
        else:
            os.startfile(folder)

    def open_run_folder(self):
        folder = self.current_run_path()
        if sys.platform.startswith('linux'):
            subprocess.call(["xdg-open", folder])
        else:
            os.startfile(folder)

    @pyqtSlot("QString", name="callSync", result=QVariant)
    @pyqtSlot("QString", "QVariantList", name="callSync", result=QVariant)
    def call_sync(self, method_name, arguments=[]):
        try:
            method = getattr(self, method_name)
            return QVariant(method(*arguments))
        except BaseException as e:  # catch any exception here
            self.dice.process_exception(e)

    @pyqtSlot("QString", name="call")
    @pyqtSlot("QString", "QVariantList", name="call")
    @pyqtSlot("QString", "QVariantList", QJSValue, name="call")
    def call(self, method_name, arguments=[], on_success=None):
        """
        Asynchronous method calling.
        :param method_name:
        :param arguments:
        :param on_success:
        :return:
        """
        self.__worker.queue.put((method_name, arguments, on_success))

    call_finished = pyqtSignal(object, QJSValue)

    def process_finished_call(self, result, callback):
        assert QThread.currentThread() == self.dice.thread()  # we must be in the main thread
        result = convert_object_to_qjsvalue(result, self.dice.qml_engine)
        callback.call([result])  # QJSValue.call expects a list here
