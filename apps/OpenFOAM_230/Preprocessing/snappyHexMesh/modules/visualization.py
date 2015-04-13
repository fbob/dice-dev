"""
Visualization
=============
"""
from core.dice.vis import *


class Visualization:

    def __init__(self):

        # material point in the scene
        # ===========================
        self.__material_point = None
        self.__ref_vis_objects = {}
        self.connect("system/snappyHexMeshDict", self.set_material_point_vis)
        self.connect("system/snappyHexMeshDict", self.set_ref_obj_vis_properties)

    def visualization_load(self):

        # Show material point in the scene
        # ================================
        self.__material_point = PointWrapper()
        self.add_vis_object(self.__material_point)
        self.__material_point.name = "Material Point"
        self.__material_point.x = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][0]
        self.__material_point.y = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][1]
        self.__material_point.z = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][2]

        self.update_visualization()

    def update_visualization(self):

        # Refinement object types in the scene
        # ====================================
        ref_obj_types = {
            "searchableBox": BoxWrapper,
            "searchableSphere": SphereWrapper,
            "searchableCylinder": TubeWrapper,
            "searchablePlate": PlaneWrapper,
            "searchablePlane": PlaneWrapper,
            "searchableDisk": DiskWrapper
        }

        for obj_name in self._snappy_hex_mesh_dict["geometry"]:
            ref_type = self._snappy_hex_mesh_dict["geometry"][obj_name]["type"]
            if ref_type in ref_obj_types:
                if obj_name not in self.__ref_vis_objects:
                    self.__ref_vis_objects[obj_name] = {
                        "object": ref_obj_types[ref_type](),
                        "type": ref_type
                    }
                    if self.__ref_vis_objects[obj_name]["object"] not in self.vis_objects:
                        self.set_init_ref_obj_vis_properties(obj_name, ref_type)
                        self.add_vis_object(self.__ref_vis_objects[obj_name]["object"])

        # remove old refinement objects
        # =============================
        for ref_vis_obj in dict(self.__ref_vis_objects):
            if ref_vis_obj not in self._snappy_hex_mesh_dict["geometry"] \
                    and self.__ref_vis_objects[ref_vis_obj]["type"] in ref_obj_types:
                del self.__ref_vis_objects[ref_vis_obj]
        vis_objects_list = [self.__ref_vis_objects[vis]["object"] for vis in self.__ref_vis_objects]
        real_ref_obj_types = [ref_obj_types[ref_obj] for ref_obj in ref_obj_types]
        for vis_obj in self.vis_objects:
            if vis_obj not in vis_objects_list:
                if type(vis_obj) in real_ref_obj_types:
                    self.remove_vis_object(vis_obj)

    def set_material_point_vis(self, var_path, value):
        if var_path[1] == "locationInMesh":
            self.__material_point.x = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][0]
            self.__material_point.y = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][1]
            self.__material_point.z = self._snappy_hex_mesh_dict["castellatedMeshControls"]["locationInMesh"][2]

    def set_init_ref_obj_vis_properties(self, obj_name, ref_type):
        self.__ref_vis_objects[obj_name]["object"].name = obj_name
        if ref_type == "searchableBox":
            self.__ref_vis_objects[obj_name]["object"].min_x = self._snappy_hex_mesh_dict["geometry"][obj_name]["min"][0]
            self.__ref_vis_objects[obj_name]["object"].min_y = self._snappy_hex_mesh_dict["geometry"][obj_name]["min"][1]
            self.__ref_vis_objects[obj_name]["object"].min_z = self._snappy_hex_mesh_dict["geometry"][obj_name]["min"][2]

            self.__ref_vis_objects[obj_name]["object"].max_x = self._snappy_hex_mesh_dict["geometry"][obj_name]["max"][0]
            self.__ref_vis_objects[obj_name]["object"].max_y = self._snappy_hex_mesh_dict["geometry"][obj_name]["max"][1]
            self.__ref_vis_objects[obj_name]["object"].max_z = self._snappy_hex_mesh_dict["geometry"][obj_name]["max"][2]

        if ref_type == "searchableSphere":
            self.__ref_vis_objects[obj_name]["object"].x = self._snappy_hex_mesh_dict["geometry"][obj_name]["centre"][0]
            self.__ref_vis_objects[obj_name]["object"].y = self._snappy_hex_mesh_dict["geometry"][obj_name]["centre"][1]
            self.__ref_vis_objects[obj_name]["object"].z = self._snappy_hex_mesh_dict["geometry"][obj_name]["centre"][2]

            self.__ref_vis_objects[obj_name]["object"].radius = self._snappy_hex_mesh_dict["geometry"][obj_name]["radius"]

        if ref_type == "searchableCylinder":
            self.__ref_vis_objects[obj_name]["object"].point1_x = self._snappy_hex_mesh_dict["geometry"][obj_name]["point1"][0]
            self.__ref_vis_objects[obj_name]["object"].point1_y = self._snappy_hex_mesh_dict["geometry"][obj_name]["point1"][1]
            self.__ref_vis_objects[obj_name]["object"].point1_z = self._snappy_hex_mesh_dict["geometry"][obj_name]["point1"][2]

            self.__ref_vis_objects[obj_name]["object"].point2_x = self._snappy_hex_mesh_dict["geometry"][obj_name]["point2"][0]
            self.__ref_vis_objects[obj_name]["object"].point2_y = self._snappy_hex_mesh_dict["geometry"][obj_name]["point2"][1]
            self.__ref_vis_objects[obj_name]["object"].point2_z = self._snappy_hex_mesh_dict["geometry"][obj_name]["point2"][2]

            self.__ref_vis_objects[obj_name]["object"].radius = self._snappy_hex_mesh_dict["geometry"][obj_name]["radius"]

        if ref_type == "searchableDisk":
            self.__ref_vis_objects[obj_name]["object"].x = self._snappy_hex_mesh_dict["geometry"][obj_name]["origin"][0]
            self.__ref_vis_objects[obj_name]["object"].y = self._snappy_hex_mesh_dict["geometry"][obj_name]["origin"][1]
            self.__ref_vis_objects[obj_name]["object"].z = self._snappy_hex_mesh_dict["geometry"][obj_name]["origin"][2]

            self.__ref_vis_objects[obj_name]["object"].norm_x = self._snappy_hex_mesh_dict["geometry"][obj_name]["normal"][0]
            self.__ref_vis_objects[obj_name]["object"].norm_y = self._snappy_hex_mesh_dict["geometry"][obj_name]["normal"][1]
            self.__ref_vis_objects[obj_name]["object"].norm_z = self._snappy_hex_mesh_dict["geometry"][obj_name]["normal"][2]

            self.__ref_vis_objects[obj_name]["object"].radius = self._snappy_hex_mesh_dict["geometry"][obj_name]["radius"]

    def set_ref_obj_vis_properties(self, var_path, value):
        ref_type = self.get_value_by_path(self._snappy_hex_mesh_dict, ["geometry", var_path[1], "type"])
        if ref_type == "searchableBox":
            if var_path[-2] == "min":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].min_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].min_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].min_z = value
            if var_path[-2] == "max":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].max_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].max_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].max_z = value

        if ref_type == "searchableSphere":
            if var_path[-2] == "centre":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].z = value
            if var_path[-1] == "radius":
                self.__ref_vis_objects[var_path[1]]["object"].radius = value

        if ref_type == "searchableCylinder":
            if var_path[-2] == "point1":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_z = value
            if var_path[-2] == "point2":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_z = value
            if var_path[-1] == "radius":
                self.__ref_vis_objects[var_path[1]]["object"].radius = value

        if ref_type == "searchableDisk":
            if var_path[-2] == "origin":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].z = value
            if var_path[-2] == "normal":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].norm_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].norm_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].norm_z = value
            if var_path[-1] == "radius":
                self.__ref_vis_objects[var_path[1]]["object"].radius = value