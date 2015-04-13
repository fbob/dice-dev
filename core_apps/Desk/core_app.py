# Standard Python modules
# =======================
import os
import shutil
from importlib import import_module
from threading import Lock
from queue import Queue

# External modules
# ================
from PyQt5.QtCore import qDebug, pyqtSignal, pyqtSlot, pyqtProperty, Qt
from PyQt5.QtQuick import QQuickItem

# DICE modules
# ============
from core.dice.core_app import CoreApp
from core.dice.tools.json_sync import JsonOrderedDict
from core.app import BasicApp


class Desk(CoreApp):
    def __init__(self, parent=None):
        super(Desk, self).__init__(parent)

        self.project_conf = None
        self.__app_classes = {}  # mapping of package names to class objects
        self.__app_classes_lock = Lock()  # to prevent creating the same app class from multiple threads
        self.__loaded_app_instances = {}  # mapping of instance names to app instances
        self.__app_list = []  # the list as represented in QML
        self.__load_queue = Queue()
        self.__opened_stream_items = set()

    def load(self):
        self.dice.executor.submit(self.__fill_app_list)

    workspace_loaded = pyqtSignal(name="workSpaceLoaded")
    stream_item_created = pyqtSignal(BasicApp, name="streamItemCreated", arguments=["streamItem"])
    stream_item_opened = pyqtSignal(BasicApp, name="streamItemOpened", arguments=["streamItem"])
    stream_item_closed = pyqtSignal(BasicApp, name="streamItemClosed", arguments=["streamItem"])
    connection_created = pyqtSignal(BasicApp, BasicApp, name="connectionCreated", arguments=["from", "to"])

    def load_desk(self, config):
        self.project_conf = config

        self.clear_workspace()
        self.__repair_desk()

        if "groups" in self.project_conf:
            for group in self.project_conf["groups"]:
                # self.__load_group(group)
                self.__load_queue.put((self.__load_group, group))

        if "apps" in self.project_conf:
            for instance_name in self.project_conf["apps"]:
                # self.__load_app(instance_name)
                self.__load_queue.put((self.__load_app, instance_name))

        if "connections" in self.project_conf:
            for conn in self.project_conf["connections"]:
                # self.__load_connection(conn)
                self.__load_queue.put((self.__load_connection, conn))

        self.dice.executor.submit(self.__process_load_queue)
        # self.workspace_loaded.emit()

    def clear_workspace(self):
        for app in list(self.__opened_stream_items):  # clone the set as it is changed in close_stream_item
            self.close_stream_item(app)

        for app in list(self.__loaded_app_instances.values()):  # clone the list here as well
            self.__delete_app_instance(app)

    def __repair_desk(self):
        project_dir = os.path.dirname(self.project_conf.file_name)
        if "apps" not in self.project_conf:
            self.project_conf["apps"] = []

        for file in os.listdir(project_dir):
            fn = os.path.join(project_dir, file)
            if os.path.isdir(fn):
                if os.path.exists(os.path.join(fn, "app.dice")) and file not in self.project_conf["apps"]:
                    self.project_conf["apps"].append(file)
        self.project_conf.write()

    def __process_load_queue(self):
        while not self.__load_queue.empty():
            method, parameter = self.__load_queue.get()
            try:
                method(parameter)
            except:
                import traceback
                qDebug(traceback.format_exc())
        self.workspace_loaded.emit()

    def __load_group(self, group_path_list):
        pass

    def __load_connection(self, conn):
        from_instance_name = conn["from"]
        to_instance_name = conn["to"]
        from_app = self.get_app(from_instance_name)
        to_app = self.get_app(to_instance_name)
        if not from_app or not to_app:
            return
        to_app.add_input_app(from_app)
        from_app.add_output_app(to_app)
        self.connection_created.emit(from_app, to_app)

    def __load_app(self, instance_name):
        qDebug("load app "+instance_name+" in "+self.dice.project.path+"@"+str(self.dice)+".."+str(self.dice.project))
        app_path = os.path.join(self.dice.project.path, "config", instance_name)
        json_file = os.path.join(app_path, "app.dice")
        if os.path.exists(json_file):
            app_conf = JsonOrderedDict(json_file)
            j = app_conf["General"]
            if "instanceName" in j and "package" in j:
                x = 0
                y = 0
                if "x" in j: x = j["x"]
                if "y" in j: y = j["y"]
                package = j["package"]

                status = j["status"] if "status" in j else ""
                app = self.__make_app_instance(package, instance_name, status)
                if app is not None:
                    # Use the protected _x and _y variables instead of the x/y properties.
                    # We do not want to write the conf file again, which is done by the properties
                    app._x = x
                    app._y = y
                    self.stream_item_created.emit(app)

    def add_app(self, instance_name):
        # add to project.dice
        if "apps" in self.project_conf:
            if instance_name not in self.project_conf["apps"]:
                self.project_conf["apps"].append(instance_name)
        else:
            self.project_conf["apps"] = [instance_name]
        self.project_conf.write()

    @pyqtSlot(BasicApp, BasicApp, name="connectStreamItems", result=bool)
    def connect_stream_items(self, app_from, app_to):
        qDebug("connect "+str(app_from)+" -> "+str(app_to))
        if app_from and app_to:
            if not app_to.accepts_input_app(app_from):
                qDebug("input app not accepted")
                return False
            app_to.add_input_app(app_from)
            app_from.add_output_app(app_to)
        else:
            qDebug("could not find an app. from: " + str(app_from) + " to: " + str(app_to))
            return False

        if "connections" not in self.project_conf:
            self.project_conf["connections"] = []

        d = {"from": app_from.instance_name, "to": app_to.instance_name}
        if d not in self.project_conf["connections"]:
            self.project_conf["connections"].append(d)
        else:
            return False
        self.project_conf.write()
        self.connection_created.emit(app_from, app_to)
        return True

    @pyqtSlot(BasicApp, BasicApp, name="disconnectStreamItems", result=bool)
    def disconnect_stream_items(self, app_from, app_to, ignore_app_to=False):
        if app_from and app_to:
            app_from.remove_output_app(app_to)
            if not ignore_app_to:
                app_to.remove_input_app(app_from)
        else:
            qDebug("could not find an app. from: " + str(app_from) + " to: " + str(app_to))
            return False

        if "connections" in self.project_conf:
            d = {"from": app_from.instance_name, "to": app_to.instance_name}
            if d in self.project_conf["connections"]:
                self.project_conf["connections"].remove(d)
                self.project_conf.write()
        return True

    def _get_project_property(self, name, default_value):
        if self.project_conf:
            if name in self.project_conf:
                return self.project_conf[name]
        return default_value

    def _set_project_property(self, name, value):
        if self.project_conf:
            self.project_conf[name] = value

    scroll_pos_x_changed = pyqtSignal(name="scrollPosXChanged")

    @property
    def scroll_pos_x(self):
        return self._get_project_property("scrollX", 0)

    @scroll_pos_x.setter
    def scroll_pos_x(self, scroll_pos_x):
        if self.scrollPosX != scroll_pos_x:
            self._set_project_property("scrollX", scroll_pos_x)
            self.scroll_pos_x_changed.emit()

    scrollPosX = pyqtProperty(int, fget=scroll_pos_x.fget, fset=scroll_pos_x.fset, notify=scroll_pos_x_changed)

    scroll_pos_y_changed = pyqtSignal(name="scrollPosYChanged")

    @property
    def scroll_pos_y(self):
        return self._get_project_property("scrollY", 0)

    @scroll_pos_y.setter
    def scroll_pos_y(self, scroll_pos_y):
        if self.scroll_pos_y != scroll_pos_y:
            self._set_project_property("scrollY", scroll_pos_y)
            self.scroll_pos_y_changed.emit()

    scrollPosY = pyqtProperty(int, fget=scroll_pos_y.fget, fset=scroll_pos_y.fset, notify=scroll_pos_y_changed)

    zoom_changed = pyqtSignal(name="zoomChanged")

    @pyqtProperty(float, notify=zoom_changed)
    def zoom(self):
        return self._get_project_property("zoom", 1.0)

    @zoom.setter
    def zoom(self, zoom):
        if self.zoom != zoom:
            self._set_project_property("zoom", zoom)
            self.zoom_changed.emit()
    
    content_width_changed = pyqtSignal(name="contentWidthChanged")
    
    @property
    def content_width(self):
        return self._get_project_property("contentWidth", 3000)
    
    @content_width.setter
    def content_width(self, content_width):
        if self.content_width != content_width:
            self._set_project_property("contentWidth", content_width)
            self.content_width_changed.emit()
    
    contentWidth = pyqtProperty(float, fget=content_width.fget, fset=content_width.fset, notify=content_width_changed)

    content_height_changed = pyqtSignal(name="contentHeightChanged")

    @property
    def content_height(self):
        return self._get_project_property("contentHeight", 1500)

    @content_height.setter
    def content_height(self, content_height):
        if self.content_height != content_height:
            self._set_project_property("contentHeight", content_height)
            self.content_height_changed.emit()

    contentHeight = pyqtProperty(float, fget=content_height.fget, fset=content_height.fset, notify=content_height_changed)

    def rename_app(self, old_instance_name, new_instance_name):
        if not old_instance_name or not new_instance_name:
            return
        if self.project_conf:
            if "apps" in self.project_conf:
                apps = self.project_conf["apps"]
                self.project_conf["apps"] = [app.replace(old_instance_name, new_instance_name) for app in apps]

            if "connections" in self.project_conf:
                for c in self.project_conf["connections"]:
                    if c["from"] == old_instance_name: c["from"] = new_instance_name
                    if c["to"] == old_instance_name: c["to"] = new_instance_name
            self.project_conf.write()
            app = self.__loaded_app_instances[old_instance_name]
            self.__loaded_app_instances[new_instance_name] = app
            del self.__loaded_app_instances[old_instance_name]

    @pyqtSlot(BasicApp, name="cloneStreamItem")
    def clone_stream_item(self, app):
        """
        Creates a clone of app.
        Simply copies the apps config and current run folder with a changed instance name and adds it to the project.
        :param app:
        :return:
        """
        new_config_path = app.appPath()+"_copy"
        if os.path.exists(new_config_path):
            raise Exception(new_config_path+" already exists")
        shutil.copytree(app.appPath(), new_config_path)
        copy_config = JsonOrderedDict(os.path.join(new_config_path, "app.dice"))
        new_instance_name = app.instance_name+"_copy"
        copy_config["General"]["instanceName"] = new_instance_name
        copy_config["General"]["x"] += 20
        copy_config["General"]["y"] += 20
        copy_config.write()

        try:
            new_run_path = app.current_run_path() + "_copy"
            shutil.copytree(app.current_run_path(), new_run_path)
        except:
            pass

        self.add_app(new_instance_name)
        self.__load_app(new_instance_name)

    def get_app(self, name):
        """

        :param name:
        :return: BasicApp
        """
        try:
            return self.__loaded_app_instances[name]
        except KeyError:
            return None

    def __make_app_instance(self, package, instance_name, status=BasicApp.IDLE):
        """
        Creates and loads an instance of the app as given by package.
        This method can be called from another than this thread. Hence the parent of the app (this desk),
        is not set in the constructor but later, after the app is moved to this thread.
        Only then the load method of the app is called.
        :param package:
        :param instance_name:
        :param status:
        :return: BasicApp
        """
        class_object = self.__get_app_class(package)
        if class_object is None:
            return None
        try:
            app = class_object(None, instance_name, status)
        except:  # any exception might happen here
            from traceback import format_exc
            exc = format_exc()
            qDebug(exc)
            return None
        self.__loaded_app_instances[instance_name] = app
        app.moveToThread(self.thread())
        app.setParent(self)
        app.load_internal()
        app.load()
        return app

    def __get_app_class(self, package):
        self.__app_classes_lock.acquire()
        if package in self.__app_classes:
            self.__app_classes_lock.release()
            return self.__app_classes[package]
        try:
            module = import_module(package+".app")
            class_name = package.split(".")[-1]
            class_object = getattr(module, class_name)
            self.__app_classes[package] = class_object
        except ImportError:
            from traceback import format_exc
            exc = format_exc()
            qDebug(exc)
            class_object = None
        self.__app_classes_lock.release()
        return class_object

    @pyqtSlot(BasicApp, name="openStreamItem")
    def open_stream_item(self, app):
        self.__opened_stream_items.add(app)
        self.stream_item_opened.emit(app)

    @pyqtSlot(BasicApp, name="closeStreamItem")
    def close_stream_item(self, app):
        self.__opened_stream_items.remove(app)
        self.stream_item_closed.emit(app)
        app.closed.emit()
        app.close()

    @pyqtSlot(str, int, int, name="createStreamItem")
    def create_stream_item(self, package, x, y):
        """
        Creates a new StreamItem on the desk with a default instance name.
        :param package:
        :param x:
        :param y:
        :return:
        """
        instance_name = self.__get_free_instance_name(package)
        app = self.__make_app_instance(package, instance_name)
        if app:
            app.x = x
            app.y = y
            self.stream_item_created.emit(app)

    def __get_free_instance_name(self, package):
        i = 1
        name = package.split(".")[-1].replace("/", "_").replace("\\", "_")
        instance_name = name+"_"+str(i)
        while instance_name in self.__loaded_app_instances:
            i += 1
            instance_name = name+"_"+str(i)
        return instance_name

    @pyqtSlot(BasicApp, name="removeStreamItem")
    def remove_stream_item(self, app):
        if app.delete_instance():
            self.__remove_all_connections_with(app)
            self.__delete_app_from_project(app)
            self.__delete_app_instance(app)

    def __remove_all_connections_with(self, app):
        for in_app in app.inputApps:
            # When removing the app as and output_app we do not want its input to change.
            # (as this might cause some exception since the app folder is already removed)
            # Hence ignore_app_to is set to True
            self.disconnect_stream_items(in_app, app, ignore_app_to=True)
        for out_app in app.outputApps:
            self.disconnect_stream_items(app, out_app)

    def __delete_app_from_project(self, app):
        instance_name = app.instance_name
        # delete from project.dice directly
        if "apps" in self.project_conf:
            self.project_conf["apps"].remove(instance_name)
            self.project_conf.write()

    def __delete_app_instance(self, app):
        self.stream_item_closed.emit(app)
        del self.__loaded_app_instances[app.instance_name]
        app.deleteLater()
        del app

    @pyqtSlot(QQuickItem, name="setQMLDesk")
    def set_qml_desk(self, desk):
        pass

    app_list_changed = pyqtSignal(name="appListChanged")

    @property
    def app_list(self):
        return self.__app_list

    @app_list.setter
    def app_list(self, app_list):
        if self.__app_list != app_list:
            self.__app_list = app_list
            self.app_list_changed.emit()

    appList = pyqtProperty("QVariantList", fget=app_list.fget, fset=app_list.fset, notify=app_list_changed)

    def __parse_apps_dir(self, dir):
        ret = []
        files = sorted(os.listdir(dir))
        for f in files:
            full_path = os.path.join(dir, f)
            if os.path.isdir(full_path) and os.path.exists(os.path.join(full_path, "app.py")):  # probably got an app
                rel_path = full_path[len(self.dice.application_dir)+1:]
                package = rel_path.replace(os.path.sep, ".")
                app_class = self.__get_app_class(package)
                if app_class is None:
                    continue
                app_name = app_class.app_name
                ret.append({"text": app_name, "name": app_name, "package": package})
            elif os.path.isdir(full_path):
                apps_dir = self.__parse_apps_dir(full_path)
                if len(apps_dir) > 0:  # ignore empty directories
                    ret.append({"text": f, "elements": apps_dir})
        return ret

    def __fill_app_list(self):
        apps_dir = os.path.join(self.dice.application_dir, "apps")
        self.__app_list = self.__parse_apps_dir(apps_dir)
        self.app_list_changed.emit()