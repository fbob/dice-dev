"""
surfaceOrient
=============
DICE surface manipulation app based on surfaceOrient in OpenFOAM
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


class surfaceOrient(FoamApp):
    """
    surfaceOrient - Utility
    =======================
    Set normal consistent with respect to a user provided ’outside’ point.
    If the -inside is used the point is considered
    inside.
    (src: http://www.openfoam.org/docs/user/standard-utilities.php)
    """

    app_name = "surfaceOrient"
    input_types = ["stl_files"]
    output_types = ["stl_files"]

    def __init__(self, parent, instance_name, status):
        FoamApp.__init__(self, parent, instance_name, status)

        # Default point
        # =============
        self.point = [100, 100, 100]

        # Default option
        # ==============
        self.option = ""

        # Input/Output objects
        # ====================
        self.__stl_input_dict = {}
        self.__input_files = []

        # TreeView model for GUI
        # ======================
        self.__tree_view_model = []

        # Visualization objects
        # =====================
        self.__input_vis = []

    def load(self):
        self.update_tree_view()

    def run(self):
        point_vector = "(" +  str(self.point[0]) + " " + str(self.point[1]) + " " + str(self.point[2]) + ")"
        for app in self.__stl_input_dict:
            for stl_file in self.__stl_input_dict[app]:
                self.debug(stl_file.filename())
                new_file_path = self.current_run_path(stl_file.filename())
                if self.option == "":
                    if self.foam_exec(["surfaceOrient", stl_file._filename, point_vector, new_file_path]) != 0:
                        return False
                else:
                    if self.foam_exec(["surfaceOrient", stl_file._filename, self.option, point_vector, new_file_path]) != 0:
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
    Point Coordinates
    =================
    '''
    def set_surface_orient_point(self, coordinate, value):
        if coordinate == "0":
            self.point[0] = value
        if coordinate == "1":
            self.point[1] = value
        if coordinate == "2":
            self.point[2] = value

    def get_surface_orient_point(self, coordinate):
        if coordinate == "0":
            return self.point[0]
        if coordinate == "1":
            return self.point[1]
        if coordinate == "2":
            return self.point[2]

    def surface_orient_point_signal_name(self, coordinate=None):
        return ""

    '''
    Option
    ======
    '''
    def set_surface_orient_option(self, value):
        if value == "None":
            self.option = ""
        self.option = value

    def get_surface_orient_option(self):
        if self.option == "None":
            return ""
        return self.option

    def surface_orient_option_signal_name(self):
        return ""

    '''
    Options Model
    =============
    '''
    def get_options_model(self):
        return ["None", "-inside", "-usePierceTest"]

    def options_model_signal_name(self):
        return ""

    '''
    Output for other Apps
    =====================
    '''
    def stl_files_out(self):
        return copy.deepcopy(self.__input_files)

    stl_files_out_changed = pyqtSignal()
