import os
from threading import Lock
from PyQt5.QtCore import  qDebug, pyqtSignal, pyqtSlot, pyqtProperty, Qt
from PyQt5.QtQuick import QQuickItem
from PyQt5.QtQml import QQmlComponent, QJSValue
from core.tools.pyqt import convert_object_to_qjsvalue


class QMLHelper:
    """
    Helper class for BasicApp that handles all view related.

    Can only be used as a base class for BasicApp, as it assumes some properties/methods like module_path().
    """
    app_qml = ""
    default_content_qml = "Content.qml"

    def __init__(self):
        self._x = 0
        self._y = 0
        self._qml_callbacks = {}
        self._desk_item = None  # the StreamItem as seen on the Desk
        self._view = None  # the App Item when the app is opened
        self.__view_creation_lock = Lock()

    def load_internal(self):
        self.qml_signal.connect(self.send_qml_signal, type=Qt.QueuedConnection)

    @property
    def qml_file(self):
        # if the qml file exists in the same directory as the python file load it,
        # otherwise load it relatively from the running DICE program
        mod_path = os.path.join(self.module_path(), self.app_qml)
        if os.path.isfile(mod_path):
            return os.path.abspath(mod_path)
        view_path = os.path.join(self.module_path(), "view", self.app_qml)
        if os.path.exists(view_path):
            # if there is a qml file in the apps content dir, load it
            if self.app_qml == "":
                view_app = os.path.join(self.module_path(), "view", "App.qml")
                if os.path.isfile(view_app):
                    return os.path.abspath(view_app)

                # if no filename given, load the default qml content dir handler
                return "libview/DICE/App/App.qml"
            else:
                return os.path.abspath(view_path)
        return ""

    @pyqtSlot("QString", QJSValue, name="setCallback")
    def set_callback(self, name, callback):
        if name not in self._qml_callbacks:
            self._qml_callbacks[name] = []
        self._qml_callbacks[name].append(callback)

    qml_signal = pyqtSignal(str, tuple)

    @pyqtSlot(str, tuple)
    def send_qml_signal(self, name, arguments=()):
        if name in self._qml_callbacks:
            for cb in self._qml_callbacks[name]:
                try:
                    cb.call([convert_object_to_qjsvalue(arg, self.dice.qml_engine) for arg in arguments])
                except BaseException as e:
                    qDebug("Could not send signal "+str(name)+"::"+str(arguments))
                    self.dice.process_exception(e)

    x_changed = pyqtSignal(name="xChanged")

    @pyqtProperty(int, notify=x_changed)
    def x(self):
        return self._x

    @x.setter
    def x(self, x):
        if self._x != x:
            self._x = x
            self.x_changed.emit()
            self.write_conf()

    y_changed = pyqtSignal(name="yChanged")

    @pyqtProperty(int, notify=y_changed)
    def y(self):
        return self._y

    @y.setter
    def y(self, y):
        if self._y != y:
            self._y = y
            self.y_changed.emit()
            self.write_conf()

    desk_item_changed = pyqtSignal(name="deskItemChanged")

    @property
    def desk_item(self):
        return self._desk_item

    @desk_item.setter
    def desk_item(self, desk_item):
        if self._desk_item != desk_item:
            self._desk_item = desk_item
            self.desk_item_changed.emit()

    deskItem = pyqtProperty(QQuickItem, fget=desk_item.fget, fset=desk_item.fset, notify=desk_item_changed)

    view_changed = pyqtSignal(name="viewChanged")

    @pyqtProperty(QQuickItem, notify=view_changed)
    def view(self):
        with self.__view_creation_lock:
            if self._view is None:
                component = QQmlComponent(self.dice.qml_engine, self.qml_file, self)
                if component.status() == QQmlComponent.Error:
                    qDebug("errors loading component: "+str(component.errors()))
                    qDebug(self.qml_file)
                    for error in component.errors():
                        qDebug(error.description())
                    return QQuickItem(self)

                # don't create the view immediately so the properties are available as soon as the view is created
                view = component.beginCreate(self.dice.qml_context)

                if view:
                    view.setParentItem(self.dice.main_window)
                    view.setProperty("appWindow", self.dice.app_window)
                    view.setProperty("app", self)
                    view.setProperty("mainWindow", self.dice.main_window)
                    self._view = view
                    component.completeCreate()
                    self.view_changed.emit()
                else:
                    component.completeCreate()
                    qDebug("no view")
                    view = QQuickItem(self)
                    view.setParentItem(self.dice.main_window)
                    # TODO: send an alert
                    return view
            return self._view

    @view.setter
    def view(self, view):
        if self._view != view:
            self._view = view
            self.view_changed.emit()

    @pyqtSlot(name="getView", result=QQuickItem)
    def get_view(self):
        """
        Need this slot aside from the view property,
        as MainWindow complains about a binding loop using the property directly.
        :return:
        """
        return self.view

    @pyqtSlot()
    def show(self):
        self.view.setVisible(True)
        self.view.setFocus(True)

    @pyqtSlot()
    def hide(self):
        if self._view:
            self._view.setVisible(False)
            self._view.setFocus(False)

    @pyqtSlot()
    def close(self):
        if self._view:
            self._view.setVisible(False)
            self._view.deleteLater()
            self._view = None

    closed = pyqtSignal(name="closed")  # emitted by desk when the app is closed

    def get_view_path(self):
        return os.path.abspath(os.path.join(self.module_path(), "view"))

    def get_main_content_path(self):
        return os.path.join(self.get_view_path(), "main")

    @pyqtSlot(name="getNaviModel", result="QVariantList")
    def get_navi_model(self):
        content = os.listdir(self.get_main_content_path())
        content.sort(key=lambda x: int(x.split("_")[0]))
        ret = list()
        for fname in content:
            full = os.path.join(self.get_main_content_path(), fname)
            num, name = fname.split("_", maxsplit=1)
            parts = name.rsplit(".", maxsplit=1)
            opt = ""
            if len(parts) == 2:
                name = parts[0]
                opt = parts[1]
            location = os.path.join(full, self.default_content_qml)
            if os.path.exists(location):
                ret.append({"listItem": name,"pageLocation": location, "description":"","sectionClass":opt})

        return ret

    @pyqtSlot(name="getNaviHeaderFile", result=str)
    def get_navi_header_file(self):
        nf = os.path.join(self.get_view_path(), "navi", "NaviHeader.qml")
        if os.path.exists(nf):
            return nf
        else:
            return ""

    @pyqtSlot(name="getNaviFile", result=str)
    def get_navi_file(self):
        nf = os.path.join(self.get_view_path(), "navi", "Navi.qml")
        if os.path.exists(nf):
            return nf
        else:
            return ""

    @pyqtSlot(name="getToolBarFile", result=str)
    def get_tool_bar_file(self):
        tf = os.path.join(self.get_view_path(), "menus", "ToolBar.qml")
        self.debug("Toolbar:"+tf)
        if os.path.exists(tf):
            return tf
        else:
            return ""

    @pyqtSlot(name="getMainHeaderFile", result=str)
    def get_main_header_file(self):
        nf = os.path.join(self.get_view_path(), "main", "MainHeader.qml")
        if os.path.exists(nf):
            return nf
        else:
            return ""

    @pyqtSlot(name="getMainHeaderMenuFile", result=str)
    def get_main_header_menu_file(self):
        nf = os.path.join(self.get_view_path(), "main", "MainHeaderMenu.qml")
        if os.path.exists(nf):
            return nf
        else:
            return ""

    @pyqtSlot(name="getVisFile", result=str)
    def get_vis_file(self):
        vf = os.path.join(self.get_view_path(), "vis", "Vis.qml")
        if os.path.exists(vf):
            return vf
        else:
            return ""

    @pyqtSlot(name="getVisHeaderFile", result=str)
    def get_vis_header_file(self):
        vf = os.path.join(self.get_view_path(), "vis", "VisHeader.qml")
        if os.path.exists(vf):
            return vf
        else:
            return ""

    @pyqtSlot(name="getActionsFile", result=str)
    def get_actions_file(self):
        af = os.path.join(self.get_view_path(), "actions", "Actions.qml")
        if os.path.exists(af):
            return af
        else:
            return ""
