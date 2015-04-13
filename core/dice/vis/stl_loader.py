# Standard Python modules
# =======================
import os

# External modules
# ================
from PyQt5.QtCore import pyqtProperty, pyqtSignal
from PyFoam.Basics.STLFile import STLFile

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class STLLoader(BasicWrapper):
    def __init__(self, stl=None, parent=None):
        """
        :param QObject parent:
        :param STLFile|str stl:
        """
        super(STLLoader, self).__init__(parent)

        if isinstance(stl, str):
            self.__stl = STLFile(stl)
        elif isinstance(stl, STLFile):
            self.__stl = stl
        else:
            raise TypeError("stl must be a STLFile or str")

        self.tree_info = [{"text": self.__stl.filename(),
                           "object" : self,
                           "elements": [{
                                "object": self,
                                "text": region["name"]
                             } for region in self.__stl.patchInfo()]}]

    file_name_changed = pyqtSignal(name="fileNameChanged")

    @property
    def file_name(self):
        return self.__stl._filename

    fileName = pyqtProperty(str, fget=file_name.fget, notify=file_name_changed)

    @property
    def basename(self):
        return os.path.basename(self.file_name)

    # @property
    # def tree_info(self):
    #     return self.__tree_info

    def has_path(self, path):
        if len(path) == 1:
            return path[0] == self.__stl.filename()
        elif len(path) == 2:
            regions = [region["name"] for region in self.__stl.patchInfo()]
            return path[0] == self.__stl.filename() and path[1] in regions
        else:
            return False