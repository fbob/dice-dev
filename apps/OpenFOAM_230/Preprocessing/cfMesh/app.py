"""
cfMesh
======
DICE meshing app based on the open source meshing library cfMesh by Creative Fields, Ltd. (http://www.c-fields.com)

Copyright (c) 2014-2015 by DICE Developers
All rights reserved.
"""

# Standard Python modules
# =======================
import os
import copy

# External modules
# ================
from PyQt5.QtCore import pyqtSignal, pyqtSlot, pyqtProperty
from PyFoam.RunDictionary.ParsedParameterFile import ParsedParameterFile

# DICE modules
# ============
from core.foamapp import FoamApp
from core.dice.vis import STLLoader, FoamMeshLoader
from core.dice.tools.foam_mesh import FoamMesh

# App modules
# ============
from .modules.surfaceGenerateBoundingBox import SurfaceGenerateBoundingBox
from .modules.object_refinements import ObjectRefinements
from .modules.visualization import Visualization
from .modules.validate import Validator


class cfMesh(FoamApp, SurfaceGenerateBoundingBox, ObjectRefinements, Visualization, Validator):
    """
    cfMesh
    ======
    cfMesh is a cross-platform library for automatic mesh generation that is built on top of OpenFOAM.
    More at: http://www.c-fields.com
    """

    app_name = "cfMesh"
    input_types = ["stl_files"]
    output_types = ["foam_mesh"]
    min_input_apps = 1
    max_input_apps = 1

    def __init__(self, parent, instance_name, status):
        """
        Constructor of cfMesh
        :param parent: The desk. It is only needed because the base class is a QObject, which needs a parent relation.
        :param instance_name: The name of the instance as seen on the desk. Can be changed by the user.
        :param status: The current status of the app. "idle" at first.
        """
        FoamApp.__init__(self, parent, instance_name, status)  # initialize the base class
        ObjectRefinements.__init__(self)
        Visualization.__init__(self)

        # Input/Output
        # ============
        self._input_file = None   # STLFile
        self.__output_mesh = None  # FoamMesh

        # TreeView model for GUI
        # ======================
        self.__tree_view_model = []

        # Parsed files
        # ============
        self._mesh_dict = None
        self.__decompose_par_dict = None
        self.__control_dict = None

        # Visualization objects
        # =====================
        self.__input_vis = None  # the visualization of the input file
        self.__output_vis = None  # output file visualization

        # Refinement objects
        # ==================
        self._object_refinements = None
        self._surface_mesh_refinement = None

        # Postprocessing
        # ==============
        self.mesh_info = {}

    def load(self):
        self.copy_template_folder()

        # Parsed files
        # ============
        self._mesh_dict = ParsedParameterFile(self.config_path('system/meshDict'))
        self.__decompose_par_dict = ParsedParameterFile(self.config_path('system/decomposeParDict'))
        self.__control_dict = ParsedParameterFile(self.config_path('system/controlDict'))

        # Registered files
        # ================
        self.register_foam_file('system/meshDict', self._mesh_dict)
        self.register_foam_file('system/decomposeParDict', self.__decompose_par_dict)
        self.register_foam_file('system/controlDict', self.__control_dict)

        # Load refinementObjects
        # ======================
        self.object_refinements_load()

        # Load function from Visualization module
        # =======================================
        self.visualization_load()

        # Load output and vis objects when app finished
        # =============================================
        if self.status == FoamApp.FINISHED:
            self.__output_mesh = FoamMesh(self.current_run_path())
            self.__load_output_vis()

        self.update_tree_view()

    def prepare(self):
        """
        Prepare run folder for running
        :return:
        """
        self.validate()
        self.copy_folder_content(self.config_path('system'), self.current_run_path('system'), overwrite=True)
        if os.path.exists(self.config_path('constant')):
            self.copy_folder_content(self.config_path('constant'), self.current_run_path('constant'), overwrite=True)
        self.copy(self._input_file._filename, self.current_run_path('constant/triSurface'))
        return True

    def run(self):
        parallel = self.config["parallelRun"]
        if parallel:
            return self.__parallel_run()
        else:
            return self.__serial_run()

    def __serial_run(self):
        mesher = self.__control_dict['application']
        if self.foam_exec([mesher, "-case", self.current_run_path()]) == 0:
            self.__handle_successful_run()
            return True
        else:
            self.__handle_failed_run()
            # return False is not really necessary, as it will return None, which acts like False in a if statement

    def __parallel_run(self):
        mesher = self.__control_dict['application']
        num_processor = self.__decompose_par_dict['numberOfSubdomains']

        self.foam_exec(["preparePar", "-case", self.current_run_path()])
        if self.foam_exec(["mpirun", "-np", str(num_processor), mesher, "-parallel", "-case", self.current_run_path()]) == 0:
            self.foam_exec(["reconstructParMesh", "-constant", "-fullMatch", "-case", self.current_run_path()])
            for i in range(num_processor):
                self.rmtree(self.current_run_path("processor"+str(i)))
            self.__handle_successful_run()
            return True
        else:
            self.__handle_failed_run()

    def __handle_successful_run(self):
        self.__output_mesh = FoamMesh(self.current_run_path())
        self.__load_output_vis()
        self.foam_mesh_out_changed.emit()

    def __handle_failed_run(self):
        self.__output_mesh = None
        if self.__output_vis:
            self.remove_vis_object(self.__output_vis)
            self.__output_vis = None

    def __load_output_vis(self):
        if self.__output_vis:
            self.remove_vis_object(self.__output_vis)
        self.__output_vis = FoamMeshLoader(self.__output_mesh)
        self.add_vis_object(self.__output_vis)

    def stl_files_in(self, input_dict):
        try:
            self._input_file = next (iter (input_dict.values()))[0]
        except (StopIteration, IndexError):
            self._input_file = None
        self.__write_stl_into_mesh_dict()
        self.update_tree_view()
        self.foam_mesh_out_changed.emit()

        if self.__input_vis:
            self.remove_vis_object(self.__input_vis)
        if self._input_file:
            self.__input_vis = STLLoader(self._input_file)
            self.add_vis_object(self.__input_vis)

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
        stl = self._input_file
        if stl is None:
            stl_model = []
        else:
            stl_model = [{
                'text': stl.filename(),
                'isRegion': False,
                'isRefinementObject': False,
                'type': 'stl_file',
                'elements': [
                    { 'text': region['name'], 'isRegion': True, 'isRefinementObject': False, 'type': 'stl_region'} for region in stl.patchInfo()
                ]
            }]

        ref_obj_model = [{
            'text': ref_obj,
            'isRegion': True,
            'isRefinementObject': True,
            'type': self._object_refinements[ref_obj]['type']
        } for ref_obj in self._object_refinements]

        ref_surface_mesh_files_model = [{
            'text': ref_surface_mesh_file,
            'isRegion': False,
            'isRefinementObject': True,
            'type': 'surface_mesh_file'
        } for ref_surface_mesh_file in self._surface_mesh_refinement]

        model = stl_model + ref_obj_model + ref_surface_mesh_files_model
        model = sorted(model, key=lambda element: element['text'])
        return model

    def update_tree_view(self):
        self.tree_view_model = self.__create_tree_view_model()
        self.update_visualization()

    '''
    Write STL-file into meshDict
    ============================
    '''
    def __write_stl_into_mesh_dict(self):
        if self._input_file is not None:
            file_path = '"constant/triSurface/{0}"'.format(self._input_file.filename())
            self._mesh_dict["surfaceFile"] = file_path
            self._mesh_dict.writeFile()
        else:
            self._mesh_dict["surfaceFile"] = '""'
            self._mesh_dict.writeFile()

    '''
    External Tools
    ==============
    '''
    def open_paraview(self):
        paraview = self.dice.settings.value(self, 'paraview')
        current_foam_path = self.current_run_path("view.foam")
        if not os.path.exists(current_foam_path):
            with open(current_foam_path, 'a'):
                os.utime(current_foam_path, None)
        self.run_process([paraview, current_foam_path])

    '''
    After Finish / With results
    ===========================
    '''
    def run_check_mesh(self):
        if self.status == FoamApp.FINISHED:
            self.foam_exec(["checkMesh", "-constant", "-allGeometry", "-allTopology", "-case", self.current_run_path()],
                           stdout=self.__process_check_mesh_output)

    def __process_check_mesh_output(self, line):
        p_line = line.strip()
        if p_line.startswith("points:"):
            self.mesh_info["points"] = int(p_line.split(":")[1])
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("faces:"):
            self.mesh_info["faces"] = int(p_line.split(":")[1])
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("cells:"):
            self.mesh_info["cells"] = int(p_line.split(":")[1])
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("Boundary openness"):
            self.mesh_info["boundary_openness"] = p_line.split()[-1]
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("Max cell openness"):
            self.mesh_info["max_cell_openness"] = p_line.split()[-1]
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("Max aspect ratio"):
            self.mesh_info["max_aspect_openness"] = p_line.split()[-1]
            self.signal(self.mesh_info_signal_name())
        elif p_line.startswith("Non-orthogonality"):
            self.mesh_info["non_orthogonality"] = p_line.split()[-1]
            self.signal(self.mesh_info_signal_name())
        elif "Max skewness" in p_line:
            max_skewness = p_line.split(" = ")[1].split(",")[0]
            self.mesh_info["max_skewness"] = max_skewness
            self.signal(self.mesh_info_signal_name())
        elif "mesh checks" in p_line:
            if "Failed" in p_line:
                self.mesh_info["mesh_checks_failed"] = int(p_line.split()[1])
        elif "Mesh OK" in p_line:
            self.mesh_info["mesh_checks_failed"] = 0

        self.read_process_line(line) # do the default log

    def get_mesh_info(self, type):
        try:
            return self.mesh_info[type]
        except:
            return ""

    def mesh_info_signal_name(self, *args):
        return "meshInfoChanged"

    def run_renumber_mesh(self):
        if self.status == FoamApp.FINISHED:
            self.foam_exec(["renumberMesh", "-overwrite", "-case", self.current_run_path()])

    def clear_mesh(self):
        if self.status == FoamApp.FINISHED:
            self.foam_exec(["foamClearPolyMesh", "-case", self.current_run_path()])
            if self.__output_vis:
                self.remove_vis_object(self.__output_vis)
                self.status = "idle"

    '''
    Output for other Apps
    =====================
    '''
    def foam_mesh_out(self):
        return copy.deepcopy(self.__output_mesh)

    foam_mesh_out_changed = pyqtSignal()