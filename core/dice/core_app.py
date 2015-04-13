import os

from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, qDebug, QUrl, QAbstractListModel, QModelIndex, \
    Qt, QVariant, QUrl
from PyQt5.QtQuick import QQuickItem

from core.app_helper.file_operations import FileOperations


class CoreApp(QObject, FileOperations):
    def __init__(self, parent=None):
        super(CoreApp, self).__init__(parent)

        # all CoreApps are instantiated by the dice instance
        self.dice = parent

        # by default the image is in the images folder as lower-case svg and the qml file is the name itself
        self.__image = os.path.join("images", self.name.lower()+".svg")
        self.__page_location = self.name+".qml"

        self.view = None  # the QML item that is assigned to this CoreApp

    def setParent(self, q_object):
        super().setParent(q_object)
        self.dice = q_object

    def load(self):
        pass

    name_changed = pyqtSignal()

    @pyqtProperty("QString", notify=name_changed)
    def name(self):
        return self.__class__.__name__

    image_changed = pyqtSignal(name="imageChanged")

    @pyqtProperty(QUrl, notify=image_changed)
    def image(self):
        # adjust the location as it is needed by the loader
        return QUrl(os.path.join("../../../core_apps", self.name, "view", self.__image))

    @image.setter
    def image(self, image):
        if self.__image != image:
            self.__image = image
            self.image_changed.emit()

    page_location_changed = pyqtSignal(name="pageLocationChanged")

    @property
    def page_location(self):
        # adjust the location as it is needed by the loader
        return QUrl(os.path.join("../../../core_apps", self.name, "view", self.__page_location))

    @page_location.setter
    def page_location(self, page_location):
        if self.__page_location != page_location:
            self.__page_location = page_location
            self.page_location_changed.emit()

    pageLocation = pyqtProperty(QUrl, fget=page_location.fget, fset=page_location.fset, notify=page_location_changed)

    @pyqtSlot(QQuickItem, name="setView")
    def set_view(self, qml_item):
        self.view = qml_item

    completed = pyqtSignal()  # this signal is sent from QML when the Component has finished loading

    @staticmethod
    def debug(msg):
        qDebug(msg)


class CoreAppListModel(QAbstractListModel):

    NameRole = Qt.UserRole + 1
    ImageRole = Qt.UserRole + 2
    PageLocationRole = Qt.UserRole + 3
    CoreAppRole = Qt.UserRole + 4

    _roles = {NameRole: "name", ImageRole: "image", PageLocationRole: "pageLocation", CoreAppRole: "coreApp"}

    def __init__(self, parent=None):
        super(CoreAppListModel, self).__init__(parent)

        self.__core_apps = []

    def add_core_app(self, core_app):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.__core_apps.append(core_app)
        self.endInsertRows()
        self.count_changed.emit()

    def append(self, core_app):
        self.add_core_app(core_app)

    def rowCount(self, parent=QModelIndex()):
        return len(self.__core_apps)

    def data(self, index, role=Qt.DisplayRole):
        try:
            core_app = self.__core_apps[index.row()]
        except IndexError:
            return QVariant()

        if role == self.NameRole:
            return core_app.name

        if role == self.ImageRole:
            return QUrl(core_app.image)

        if role == self.PageLocationRole:
            return QUrl(core_app.page_location)

        if role == self.CoreAppRole:
            return core_app

        return QVariant()

    def roleNames(self):
        return self._roles

    count_changed = pyqtSignal(name="countChanged")

    @pyqtProperty(int, notify=count_changed)
    def count(self):
        return len(self.__core_apps)

    @pyqtSlot(int, result=CoreApp)
    def get(self, index):
        try:
            return self.__core_apps[index]
        except IndexError:
            return CoreApp()

    @pyqtSlot("QString", result=CoreApp, name="getByName")
    def get_by_name(self, name):
        for core_app in self.__core_apps:
            if core_app.name == name:
                return core_app
        else:
            return CoreApp()
