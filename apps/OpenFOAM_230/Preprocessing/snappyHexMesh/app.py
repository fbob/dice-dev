"""
snappyHexMesh
=============
DICE meshing app based on snappyHexMesh in OpenFOAM (http://www.openfoam.org)

Copyright (c) 2014-2015 by DICE Developers
All rights reserved.
"""

# Standard Python modules
# =======================
import os
import copy

# External modules
# ================
from PyFoam.RunDictionary.ParsedParameterFile import ParsedParameterFile
from PyQt5.QtCore import pyqtSignal, pyqtSlot, pyqtProperty

# DICE modules
# ============
from core.foamapp import FoamApp
from core.dice.vis import STLLoader, FoamMeshLoader, PointWrapper
from core.dice.tools.foam_mesh import FoamMesh

# App modules
# ============
from .modules.bounding_box import BoundingBox
from .modules.refinement_objetcs import RefinementObjects
from .modules.visualization import Visualization


class snappyHexMesh(FoamApp, BoundingBox, RefinementObjects, Visualization):
    """
    snappyHexMesh
    =============
    The snappyHexMesh utility generates 3-dimensional meshes containing hexahedra (hex) and split-hexahedra (split-hex)
    automatically from triangulated surface geometries in Stereolithography (STL) format.
    """

    app_name = "snappyHexMesh"
    input_types = ["stl_files"]
    output_types = ["foam_mesh"]

    def __init__(self, parent, instance_name, status):
        """
        Constructor of snappyHexMesh
        :param parent: The desk. It is only needed because the base class is a QObject, which needs a parent relation.
        :param instance_name: The name of the instance as seen on the desk. Can be changed by the user.
        :param status: The current status of the app. "idle" at first.
        """

        FoamApp.__init__(self, parent, instance_name, status)  # initialize the base class
        BoundingBox.__init__(self)
        RefinementObjects.__init__(self)
        Visualization.__init__(self)

        # Input/Output objects
        # ====================
        self._input_files = []  # STLFiles
        self.__output_mesh = []  # FoamMesh

        # TreeView model for GUI
        # ======================
        self.__tree_view_model = []

        # Parsed files
        # ============
        self._block_mesh_dict = None
        self._snappy_hex_mesh_dict = None
        self.__mesh_quality_dict = None
        self.__surface_feature_extract_dict = None
        self.__decompose_par_dict = None
        self.__control_dict = None

        # Visualization objects
        # =====================
        self.__input_vis = []  # the visualization of the input file
        self.__output_vis = None  # output file visualization

        # Refinement objects
        # ==================
        self._refinement_objects = {}

        # Postprocessing
        # ==============
        self.mesh_info = {}

    def load(self):
        self.copy_template_folder()

        # Parsed files
        # ============
        self._block_mesh_dict = ParsedParameterFile(self.config_path('constant/polyMesh/blockMeshDict'))
        self._snappy_hex_mesh_dict = ParsedParameterFile(self.config_path('system/snappyHexMeshDict'))
        self.__mesh_quality_dict = ParsedParameterFile(self.config_path('system/meshQualityDict'))
        self.__surface_feature_extract_dict = ParsedParameterFile(self.config_path('system/surfaceFeatureExtractDict'))
        self.__decompose_par_dict = ParsedParameterFile(self.config_path('system/decomposeParDict'))
        self.__control_dict = ParsedParameterFile(self.config_path('system/controlDict'))

        # Registered files
        # ================
        self.register_foam_file('constant/polyMesh/blockMeshDict', self._block_mesh_dict)
        self.register_foam_file('system/snappyHexMeshDict', self._snappy_hex_mesh_dict)
        self.register_foam_file('system/meshQualityDict', self.__mesh_quality_dict)
        self.register_foam_file('system/surfaceFeatureExtractDict', self.__surface_feature_extract_dict)
        self.register_foam_file('system/decomposeParDict', self.__decompose_par_dict)
        self.register_foam_file('system/controlDict', self.__control_dict)

        # Load function from BoundingBox module
        # =====================================
        self.bounding_box_load()

        # Load function from Visualization module
        # =======================================
        self.visualization_load()

        # Load functions from Refinement Objects module
        # =============================================
        self.refinement_objects_load()

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
        self.clear_folder_content(self.current_run_path())
        self.copy_folder_content(self.config_path('constant', 'polyMesh'), self.current_run_path('constant', 'polyMesh'), overwrite=True)
        self.copy_folder_content(self.config_path('system'), self.current_run_path('system'), overwrite=True)
        for input_file in self._input_files:
            self.copy(input_file._filename, self.current_run_path('constant/triSurface'))
        return True

    def run(self):
        parallel = self.config["parallelRun"]
        if parallel:
            return self.__parallel_run()
        else:
            return self.__serial_run()

    def __serial_run(self):
        self.foam_exec(["surfaceFeatureExtract", "-case", self.current_run_path()])
        mesher = self.__control_dict['application']
        if self.foam_exec(["blockMesh", "-case", self.current_run_path()]) == 0:
            if self.foam_exec([mesher, "-overwrite", "-case", self.current_run_path()]) == 0:
                self.__handle_successful_run()
                return True
            else:
                self.__handle_failed_run()
                # return False is not really necessary, as it will return None, which acts like False in a if statement

    def __parallel_run(self):
        self.foam_exec(["surfaceFeatureExtract", "-case", self.current_run_path()])

        mesher = self.__control_dict['application']
        num_processor = self.__decompose_par_dict['numberOfSubdomains']

        if self.foam_exec(["blockMesh", "-case", self.current_run_path()]) == 0:
            if self.foam_exec(["decomposePar", "-force", "-case", self.current_run_path()]) == 0:
                if self.foam_exec(["mpirun", "-np", str(num_processor), mesher, "-overwrite", "-parallel", "-case", self.current_run_path()]) == 0:
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

    '''
    Input from other Apps
    =====================
    '''
    def stl_files_in(self, input_dict):
        self._input_files = []
        for files in input_dict.values():
            self._input_files.extend(files)
        self.__write_stl_into_snappy_hex_mesh_dict()
        self.update_tree_view()
        self.foam_mesh_out_changed.emit()

        for iv in self.__input_vis:
            self.remove_vis_object(iv)
        self.__input_vis = []
        for input_file in self._input_files:
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

    def get_ref_object_type(self, ref_obj_name):
        """
        Function to get the right type because of the different searchable planeTypes
        :param ref_obj_name:
        :return:
        """
        ref_obj = self._refinement_objects[ref_obj_name]
        if ref_obj["type"] == "searchablePlane":
            if ref_obj["planeType"] == "pointAndNormal":
                return "searchablePlanePaN"
            elif ref_obj["planeType"] == "embeddedPoints":
                return "searchablePlane3P"
        else:
            return ref_obj["type"]

    def __create_tree_view_model(self):
        stl_model = [{
            'text': stl.filename(),
            'isRegion': self.get_convert_to_region(stl.filename),
            'isRefinementObject': False,
            'type': 'stl_file',
            'elements': [
                {'text': region['name'], 'isRegion': True, 'isRefinementObject': False, 'type': 'stl_region' } for region in stl.patchInfo()
            ]
        } for stl in self._input_files]

        ref_obj_model = [{
            'text': ref_obj,
            'isRegion': True,
            'isRefinementObject': True,
            'type': self.get_ref_object_type(ref_obj)
        } for ref_obj in self._refinement_objects]

        model = stl_model + ref_obj_model
        model = sorted(model, key=lambda element: element['text'])
        return model

    def update_tree_view(self):
        self.tree_view_model = self.__create_tree_view_model()
        self.update_visualization()

    '''
    snappyHexMeshDict
    =================
    '''
    def __write_stl_into_snappy_hex_mesh_dict(self):
        for stl in self._input_files:
            if stl.filename() not in self._snappy_hex_mesh_dict["geometry"]:
                self._snappy_hex_mesh_dict["geometry"][stl.filename()] = {
                    "type": "triSurfaceMesh",
                    "name": stl.filename(),
                    "regions": { region['name']: {'name' : region['name'] } for region in stl.patchInfo()}
                }
        self.__synchronize_surface_refinement_dict()
        self.__remove_old_stl_from_snappy_hex_mesh_dict()
        self._snappy_hex_mesh_dict.writeFile()

    def __remove_old_stl_from_snappy_hex_mesh_dict(self):
        stl_file_names = [stl.filename() for stl in self._input_files]
        for geom in dict(self._snappy_hex_mesh_dict["geometry"]):
            if geom not in stl_file_names and self._snappy_hex_mesh_dict["geometry"][geom]["type"] == "triSurfaceMesh":
                del self._snappy_hex_mesh_dict["geometry"][geom]
        self._snappy_hex_mesh_dict.writeFile()

    def __synchronize_surface_refinement_dict(self):
        for stl in self._input_files:
            if stl.filename() not in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"]:
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"][stl.filename()] = {
                    "level": [0, 0],
                    "regions": { region['name']: {'level': [0, 0]} for region in stl.patchInfo()}
                }
        for old_stl in dict(self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"]):
            file_names = [stl_name.filename() for stl_name in self._input_files]
            if old_stl not in file_names:
                del self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"][old_stl]
        self._snappy_hex_mesh_dict.writeFile()

    def create_default_region_level(self, path):
        self.create_foam_var(path + " level", [0, 0])
        self._snappy_hex_mesh_dict.writeFile()

    '''
    FeatureRefinement
    =================
    '''
    def get_file_index(self, path):
        self.debug("get file index of "+str(path))
        file_name = os.path.splitext(path)[0]
        file_dict_value = '"{0}.eMesh"'.format(file_name)
        for f_dict in self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"]:
            if f_dict["file"] == file_dict_value:
                return str(self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"].index(f_dict))
        return ""

    def add_feature(self, path):
        self.debug("add feature: "+str(path))
        file_name = os.path.splitext(path)[0]
        file_name_e_mesh = '"{0}.eMesh"'.format(file_name)
        for feature_dict in self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"]:
            if feature_dict["file"] == file_name_e_mesh:
                self.debug("already exists")
                return
        self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"].append(
            {
                "file": file_name_e_mesh,
                "levels": [[0, 0]]
            }
        )
        self._snappy_hex_mesh_dict.writeFile()

        for feature_dict in self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"]:
            if path in self.__surface_feature_extract_dict:
                self.debug("already exists")
                return
        self.__surface_feature_extract_dict[path] = {
            "extractionMethod": "extractFromSurface",
            "extractFromSurfaceCoeffs": {
                "includedAngle": 0
            },
            "subsetFeatures": {
                "nonManifoldEdges": "no",
                "openEdges": "yes",
                "insideBox": '(0 0 0) (1 1 1)'
            },
            "writeObj": "yes"
        }
        self.__surface_feature_extract_dict.writeFile()
        self.signal("featureLevelsListChanged")

    def remove_feature(self, path):
        file_name = os.path.splitext(path)[0]
        file_dict_value = '"{0}.eMesh"'.format(file_name)
        for f_dict in self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"]:
            if f_dict["file"] == file_dict_value:
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"].remove(f_dict)
                self.debug(str(f_dict))
        self._snappy_hex_mesh_dict.writeFile()
        try:
            del self.__surface_feature_extract_dict[path]
            self.__surface_feature_extract_dict.writeFile()
            self.signal("featureLevelsListChanged")
        except KeyError:
            pass

    feature_levels_list_changed = pyqtSignal(name="featureLevelsListChanged")

    def get_feature_levels_list_length(self, file_index):
        try:
            length = len(self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"][int(file_index)]["levels"])
            return {"length": length}
        except:
            return {"length": 0}

    def add_feature_level(self, file_index, levels_list_length):
        try:
            if levels_list_length > 0:
                last_distance = self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"][int(file_index)]["levels"][levels_list_length-1][0]
                new_default_distance = last_distance*1.1
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"][int(file_index)]["levels"].append([new_default_distance, 0])
            else:
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"][int(file_index)]["levels"].append([0, 0])
            self._snappy_hex_mesh_dict.writeFile()
            self.signal("featureLevelsListChanged")
        except KeyError:
            self.debug("can't add feature level")

    def remove_feature_level(self, file_index, list_index, file_name):
        try:
            del self._snappy_hex_mesh_dict["castellatedMeshControls"]["features"][int(file_index)]["levels"][list_index]
            self._snappy_hex_mesh_dict.writeFile()
            self.signal("featureLevelsListChanged")
        except KeyError:
            self.debug("can't remove feature level")

    '''
    Region Refinement
    =================
    '''
    region_levels_list_changed = pyqtSignal(name="regionLevelsListChanged")

    def get_region_levels_list_length(self, region_name):
        try:
            length = len(self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"])
            return {"length": length}
        except:
            self.debug("can't get length of the list for region")
            return {"length": 0}

    def add_region_level(self, region_name, levels_list_length, region_type):
        if region_type in {"searchableBox", "searchableSphere", "searchableCylinder", "stl_file"}:
            default_mode = "inside"
        else:
            default_mode = "distance"
        try:
            if levels_list_length > 0:
                last_distance = self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"][levels_list_length-1][0]
                new_default_distance = last_distance*1.1
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"].append([new_default_distance, 0])
            elif region_name not in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"]:
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name] = {
                    "mode": default_mode,
                    "levels": [[0, 0]]
                }
            else:
                self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"].append([0, 0])
            self._snappy_hex_mesh_dict.writeFile()
            self.signal("regionLevelsListChanged")
        except KeyError:
            self.debug("can't add region level")

    def remove_region_level(self, region_name, list_index):
        try:
            del self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"][list_index]
            if len(self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]["levels"]) == 0:
                del self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][region_name]
            self._snappy_hex_mesh_dict.writeFile()
            self.signal("regionLevelsListChanged")
        except KeyError:
            self.debug("can't remove region level")

    '''
    Convert to Region
    =================
    '''
    def set_convert_to_region(self, surface_name, checked):
        if checked:
            if surface_name in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"]:
                surface_dict = self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"][surface_name]
                if "faceZone" and "cellZone" and "cellZoneInside" and "faceType" not in surface_dict:
                    surface_dict["faceZone"] = surface_name
                    surface_dict["cellZone"] = surface_name
                    surface_dict["cellZoneInside"] = "inside"
                    surface_dict["faceType"] = "internal"
                    self.update_tree_view()
                    self._snappy_hex_mesh_dict.writeFile()
        if not checked:
            if surface_name in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"]:
                surface_dict = self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"][surface_name]
                if "faceZone" and "cellZone" and "cellZoneInside" and "faceType" in surface_dict:
                    del surface_dict["faceZone"]
                    del surface_dict["cellZone"]
                    del surface_dict["cellZoneInside"]
                    del surface_dict["faceType"]
                    self.update_tree_view()
                    self._snappy_hex_mesh_dict.writeFile()

    def get_convert_to_region(self, surface_name):
        if surface_name in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"]:
            surface_dict = self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementSurfaces"][surface_name]
            if "faceZone" and "cellZone" and "cellZoneInside" in surface_dict:
                return True
        return False

    def convert_to_region_signal_name(self):
        return "system/snappyHexMeshDict"

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



