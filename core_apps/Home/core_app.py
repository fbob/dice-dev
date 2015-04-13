import os
from PyQt5.QtCore import pyqtSignal, pyqtProperty, qDebug, pyqtSlot

from core.dice.core_app import CoreApp
from core.dice.tools.json_sync import JsonList


class Home(CoreApp):
    def __init__(self, parent=None):
        super(Home, self).__init__(parent)

        settings_folder = os.path.join(os.path.expanduser("~"), ".config", "DICE")
        if not os.path.exists(settings_folder):
            os.makedirs(settings_folder)

        self.__recent_projects = JsonList(os.path.join(settings_folder, "recent_projects.json"))
        self.__max_recent_projects = 10  # TODO: get this value from settings

    recent_projects_changed = pyqtSignal(name="recentProjectsChanged")

    @property
    def recent_projects(self):
        return self.__recent_projects.to_simple_list()

    recentProjects = pyqtProperty("QVariantList", fget=recent_projects.fget, notify=recent_projects_changed)

    def add_recent_project(self, project_name, location):
        recent_locations = [recent_project['location'] for recent_project in self.__recent_projects]
        recent_project = {'projectName': project_name, 'location': location}

        if location not in recent_locations:
            self.__recent_projects.insert(0, recent_project)
            while len(self.__recent_projects) > self.__max_recent_projects:
                self.__recent_projects.pop()
            self.recent_projects_changed.emit()
        else:
            # add the project on top of the list
            index = self.__recent_projects.index(recent_project)
            if index != 0:
                self.__recent_projects.pop(index)
                self.__recent_projects.insert(0, recent_project)
                self.recent_projects_changed.emit()

    @pyqtSlot(name="closeProject")
    def close_project(self):
        self.dice.project.close()
        self.dice.desk.clear_workspace()