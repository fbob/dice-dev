"""
Refinement Objects
==================
"""


class RefinementObjects:

    def __init__(self):

        self.debug("Initialize refinement objects")

    def refinement_objects_load(self):

        # Load refinementObjects
        # ======================
        ref_obj_types = {
            "searchableBox",
            "searchableSphere",
            "searchableCylinder",
            "searchablePlate",
            "searchablePlane",
            "searchableDisk"
        }

        for obj in self._snappy_hex_mesh_dict["geometry"]:
            if self._snappy_hex_mesh_dict["geometry"][obj]["type"] in ref_obj_types:
                self._refinement_objects[obj] = self._snappy_hex_mesh_dict["geometry"][obj]

    def add_refinement_object(self, name, i=0):

        ref_object_templates = {
            "refinementBox": {
                "type": "searchableBox",
                "min": [0, 0, 0],
                "max": [1, 1, 1]
            },
            "refinementSphere": {
                "type": "searchableSphere",
                "centre": [0, 0, 0],
                "radius": 1
            },
            "refinementCylinder": {
                "type": "searchableCylinder",
                "point1": [0, 0, 0],
                "point2": [1, 0, 0],
                "radius": 1
            },
            "refinementPlate": {
                "type": "searchablePlate",
                "origin": [0, 0, 0],
                "span": [1, 2, 0]
            },
            "refinementPlanePaN": {
                "type": "searchablePlane",
                "planeType": "pointAndNormal",
                "pointAndNormalDict": {
                    "basePoint": [0, 0, 0],
                    "normalVector": [1, 0, 0]
                }
            },
            "refinementPlane3P": {
                "type": "searchablePlane",
                "planeType": "embeddedPoints",
                "embeddedPointsDict": {
                    "point1": [0, 0, 0],
                    "point2": [1, 0, 1],
                    "point3": [1, 0, 2]
                }
            },
            "refinementDisk": {
                "type": "searchableDisk",
                "origin": [0, 0, 0],
                "normal": [0, 0, 1],
                "radius": 1
            }
        }

        if name not in self._refinement_objects:
            self._snappy_hex_mesh_dict["geometry"][name] = ref_object_templates[name.split('_')[0]]
            self._refinement_objects[name] = self._snappy_hex_mesh_dict["geometry"][name]
            self._snappy_hex_mesh_dict.writeFile()
            self.update_tree_view()
        else:
            new_name = name.split('_')[0] + "_" + str(i)
            i += 1
            name = self.add_refinement_object(new_name, i)
        return name

    def remove_refinement_object(self, name):
        if name in self._refinement_objects:
            del self._snappy_hex_mesh_dict["geometry"][name]
            if name in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"]:
                del self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][name]
            del self._refinement_objects[name]
            self._snappy_hex_mesh_dict.writeFile()
            self.update_tree_view()

    def rename_refinement_object(self, old_name, new_name):
        if old_name in self._refinement_objects:
            if new_name not in self._refinement_objects and new_name not in self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"]:
                self._snappy_hex_mesh_dict["geometry"][new_name] = self._snappy_hex_mesh_dict["geometry"][old_name]
                self._refinement_objects[new_name] = self._refinement_objects[old_name]
                del self._snappy_hex_mesh_dict["geometry"][old_name]
                del self._refinement_objects[old_name]
                try:
                    self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][new_name] \
                        = self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][old_name]
                    del self._snappy_hex_mesh_dict["castellatedMeshControls"]["refinementRegions"][old_name]
                except:
                    pass
                self._snappy_hex_mesh_dict.writeFile()
                self.update_tree_view()
                return False  # show no warning in gui
        # TODO: bad style: return True on success, not on failure
        return True

