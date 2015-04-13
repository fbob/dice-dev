"""
surfaceCheck
============
DICE surface manipulation app based on surfaceCheck in OpenFOAM
(http://www.openfoam.org)

Copyright (c) 2014-2015 by DICE Developers
All rights reserved.
"""

# Standard Python modules
# =======================
import copy

# External modules
# ================
from PyQt5.QtCore import pyqtSignal, pyqtSlot, pyqtProperty

# DICE modules
# ============
from core.foamapp import FoamApp
from core.dice.vis import STLLoader


class surfaceCheck(FoamApp):
    """
    surfaceCheck - Utility
    ======================
    Checks geometric and topological quality of a surface.
    (src: http://www.openfoam.org/docs/user/standard-utilities.php)
    """

    app_name = "surfaceCheck"
    input_types = ["stl_files"]
    output_types = ["stl_files"]

    def __init__(self, parent, instance_name, status):
        FoamApp.__init__(self, parent, instance_name, status)

        # Input/Output objects
        # ====================
        self.__stl_input_dict = {}
        self.__input_files = []

        # TreeView model for GUI
        # ======================
        self.__tree_view_model = []

        # Visualization objects
        # =====================
        self.__input_vis = []  # the visualization of the input file

    def load(self):
        self.update_tree_view()

    def run(self):
        for app in self.__stl_input_dict:
            for stl_file in self.__stl_input_dict[app]:
                if self.foam_exec(["surfaceCheck", stl_file._filename]) != 0:
                    return False
        return True

    def stl_files_in(self, input_dict):
        self.__input_files = []
        self.__stl_input_dict = input_dict
        for files in input_dict.values():
            self.__input_files.extend(files)
        self.update_tree_view()
        self.stl_files_out_changed.emit()

        for iv in self.__input_vis:
            self.remove_vis_object(iv)
        self.__input_vis = []
        for input_file in self.__input_files:
            input_vis = STLLoader(input_file)
            self.__input_vis.append(input_vis)
            self.add_vis_object(input_vis)

    '''
    TreeView for app
    ================
    '''
    tree_view_model_changed = pyqtSignal(name="treeViewModelChanged")

    @property
    def tree_view_model(self):
        return self.__tree_view_model

    @tree_view_model.setter
    def tree_view_model(self, tree_view_model):
        if self.__tree_view_model != tree_view_model:
            self.__tree_view_model = tree_view_model
            self.tree_view_model_changed.emit()

    treeViewModel = pyqtProperty("QVariantList", fget=tree_view_model.fget, fset=tree_view_model.fset,
                                 notify=tree_view_model_changed)

    def __create_tree_view_model(self):
        stl_model = [{
            'text': stl.filename(),
            'isRegion': False,
            'isRefinementObject': False,
            'type': 'stl_file',
            'elements': [
                { 'text': region['name'], 'isRegion': True, 'isRefinementObject': False, 'type': 'stl_region' } for region in stl.patchInfo()
            ]
        } for stl in self.__input_files]
        return stl_model

    def update_tree_view(self):
        self.tree_view_model = self.__create_tree_view_model()

    '''
    Output for other Apps
    =====================
    '''
    def stl_files_out(self):
        return copy.deepcopy(self.__input_files)

    stl_files_out_changed = pyqtSignal()
