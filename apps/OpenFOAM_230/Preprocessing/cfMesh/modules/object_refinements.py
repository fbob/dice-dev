"""
Object Refinements
==================
"""

# Standard Python modules
# =======================
import os

# External modules
# ================
from PyFoam.Basics.STLFile import STLFile


class ObjectRefinements:

    def __init__(self):

        self.debug("Initialize object refinements")
        self._surface_mesh_refinement_files = []

    def object_refinements_load(self):

        # Load objectRefinements
        # ======================

        if "objectRefinements" not in self._mesh_dict:
            self._mesh_dict["objectRefinements"] = {}
        self._object_refinements = self._mesh_dict["objectRefinements"]

        if "surfaceMeshRefinement" not in self._mesh_dict:
            self._mesh_dict["surfaceMeshRefinement"] = {}
        self._surface_mesh_refinement = self._mesh_dict["surfaceMeshRefinement"]
        for surface_file in self._surface_mesh_refinement:
            surface_file_url = self._surface_mesh_refinement[surface_file]["surfaceFile"].split('"')[1]
            surface_file_object = STLFile(self.config_path(surface_file_url))
            self._surface_mesh_refinement_files.append(surface_file_object)

    def add_object_refinements(self, name, i=0):

        ref_object_templates = {
            "refinementBox": {
                "type": "box",
                "cellSize": 1,
                "centre": [0, 0, 0],
                "lengthX": 1,
                "lengthY": 1,
                "lengthZ": 1
            },
            "refinementSphere": {
                "type": "sphere",
                "cellSize": 1,
                "centre": [0, 0, 0],
                "radius": 1,
                "refinementThickness": 1
            },
            "refinementCone": {
                "type": "cone",
                "cellSize": 1,
                "p0": [0, 0, 0],
                "p1": [1, 0, 0],
                "radius0": 1,
                "radius1": 1
            },
            "refinementLine": {
                "type": "line",
                "cellSize": 1,
                "p0": [0, 0, 0],
                "p1": [1, 0, 0],
                "refinementThickness": 1
            }
        }

        if name not in self._object_refinements:
            self._object_refinements[name] = ref_object_templates[name.split('_')[0]]
            self._mesh_dict.writeFile()
            self.update_tree_view()
        else:
            new_name = name.split('_')[0] + "_" + str(i)
            i += 1
            name = self.add_object_refinements(new_name, i)
        return name

    def remove_refinement_object(self, name, ref_obj_type):
        if name in self._object_refinements:
            del self._object_refinements[name]
            self._mesh_dict.writeFile()
            self.update_tree_view()
        if ref_obj_type == "surface_mesh_file":
            if name in self._surface_mesh_refinement:
                file_path = self.config_path("constant/triSurface/surfaceMeshRefinementObjects", name)
                self.rm(file_path)
                del self._surface_mesh_refinement[name]
                self._mesh_dict.writeFile()
                self.update_tree_view()

    def rename_refinement_object(self, old_name, ref_obj_type, new_name):
        if old_name in self._object_refinements:
            if new_name not in self._object_refinements:
                self._object_refinements[new_name] = self._object_refinements[old_name]
                del self._object_refinements[old_name]
                self.foam_files["system/meshDict"].writeFile()
                self.update_tree_view()
                return False  # show no warning in gui
        elif ref_obj_type == 'surface_mesh_file' and old_name in self._surface_mesh_refinement:
            if new_name not in self._surface_mesh_refinement:
                old_path = self.config_path('constant/triSurface/surfaceMeshRefinementObjects', old_name)
                new_path = self.config_path('constant/triSurface/surfaceMeshRefinementObjects', new_name)
                if not os.path.exists(new_path):
                    self.move(old_path, new_path)
                    self._surface_mesh_refinement[new_name] = self._surface_mesh_refinement[old_name]
                    del self._surface_mesh_refinement[old_name]
                    new_surface_file = '"{0}/{1}"'.format("constant/triSurface/surfaceMeshRefinementObjects", new_name)
                    self._surface_mesh_refinement[new_name]['surfaceFile'] = new_surface_file
                    self.foam_files["system/meshDict"].writeFile()
                    self.update_tree_view()
                    return False  # show no warning in gui
        # TODO: bad style: return True on success, not on failure
        return True  # show warning in gui

    '''
    Surface Mesh Refinement Files
    =============================
    '''
    def add_surface_mesh_refinement(self, file_url):
        file_src = file_url.toLocalFile()
        file_dst = self.config_path("constant/triSurface/surfaceMeshRefinementObjects")
        name = os.path.split(file_src)[-1]
        if name not in self._surface_mesh_refinement:
            self.copy(file_src, file_dst)
            self._surface_mesh_refinement[name] = {
                "surfaceFile": '"{0}/{1}"'.format("constant/triSurface/surfaceMeshRefinementObjects", name),
                "additionalRefinementLevels": 1,
                "refinementThickness": 1
            }
            self.foam_files["system/meshDict"].writeFile()
            self.update_tree_view()