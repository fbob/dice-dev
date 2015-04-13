# Standard Python modules
# =======================
import os

# External modules
# ================
from PyQt5.QtCore import pyqtProperty, pyqtSignal

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class FoamMeshLoader(BasicWrapper):
    def __init__(self, foam_mesh, parent=None):
        """
        :param FoamMesh foam_mesh: the FoamMesh to visualize
        :param parent:
        """
        super().__init__(parent)

        self.__foam_mesh = foam_mesh

        self.__tree_info = [{"text": os.path.basename(foam_mesh.path),
                             # "elements": [{"text": region["name"]} for region in self.__stl.patchInfo()]
                            }]

    file_name_changed = pyqtSignal(name="fileNameChanged")

    @property
    def file_name(self):
        return self.__foam_mesh.file_name

    fileName = pyqtProperty(str, fget=file_name.fget, notify=file_name_changed)

    @property
    def tree_info(self):
        return self.__tree_info

    def has_path(self, path):
        if len(path) == 1:
            basename = os.path.basename(self.__foam_mesh.path)
            return path[0] == basename
        else:
            return False