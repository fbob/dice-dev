# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot

# DICE modules
# ============
from core.dice.scheduler import Scheduler
from core.app import BasicApp


class Project(QObject):
    def __init__(self, parent=None):
        super(Project, self).__init__(parent)

        self.dice = parent
        self.__name = ""
        self.__path = ""
        self.__loaded = False

        self.scheduler = Scheduler(self)
        self.project_config = None

    name_changed = pyqtSignal(name="nameChanged")

    @pyqtProperty("QString", notify=name_changed)
    def name(self):
        return self.__name

    @name.setter
    def name(self, name):
        if self.__name != name:
            self.__name = name
            self.name_changed.emit()

    path_changed = pyqtSignal(name="pathChanged")

    @pyqtProperty("QString", notify=path_changed)
    def path(self):
        return self.__path

    @path.setter
    def path(self, path):
        if self.__path != path:
            self.__path = path
            self.path_changed.emit()

    loaded_changed = pyqtSignal(name="loadedChanged")

    @pyqtProperty(bool, notify=loaded_changed)
    def loaded(self):
        return self.__loaded

    @loaded.setter
    def loaded(self, loaded):
        if self.__loaded != loaded:
            self.__loaded = loaded
            self.loaded_changed.emit()

    @pyqtSlot(BasicApp, name="scheduleRun")
    def schedule_run(self, app):
        self.scheduler.schedule_run(app)

    @pyqtSlot(BasicApp, name="schedulePrepare")
    def schedule_prepare(self, app):
        self.scheduler.schedule_prepare(app)

    @pyqtSlot()
    def close(self):
        """
        Called by DICE when a project is closed. E.g. when the program closes or another project is loaded
        """
        self.loaded = False
