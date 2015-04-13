"""
Visualization
=============
"""
from core.dice.vis import *


class Visualization:

    def __init__(self):

        self.__ref_vis_objects = {}
        self.__surf_ref_vis_objects = {}
        self.connect("system/meshDict", self.set_ref_obj_vis_properties)

    def visualization_load(self):
        self.update_visualization()

    def update_visualization(self):

        # for surface_file in self._surface_mesh_refinement_files:
        #     self.__surf_ref_vis_objects[surface_file.filename()] = {
        #         "object": STLLoader(surface_file),
        #         "type": "surfaceMeshFile"
        #     }
        #     if self.__surf_ref_vis_objects[surface_file.filename()]["object"] not in self.vis_objects:
        #         self.add_vis_object(self.__surf_ref_vis_objects[surface_file.filename()]["object"])
        #
        # self.debug("STL files "+str(self._surface_mesh_refinement_files))
        # self.debug("STL files vis "+str(self.vis_objects))

        obj_ref_types = {
            "box": BoxWrapper,
            "sphere": SphereWrapper,
            "cone": Cone2RWrapper,
            "line": TubeWrapper,
        }

        for obj_name in self._object_refinements:
            ref_type = self._object_refinements[obj_name]["type"]
            if ref_type in obj_ref_types:
                self.__ref_vis_objects[obj_name] = {
                    "object": obj_ref_types[ref_type](),
                    "type": ref_type
                }
                if self.__ref_vis_objects[obj_name]["object"] not in self.vis_objects:
                    self.set_init_ref_obj_vis_properties(obj_name, ref_type)
                    self.add_vis_object(self.__ref_vis_objects[obj_name]["object"])

        # remove old refinement objects
        # =============================
        for ref_vis_obj in dict(self.__ref_vis_objects):
            if ref_vis_obj not in self._object_refinements \
                    and self.__ref_vis_objects[ref_vis_obj]["type"] in obj_ref_types:
                del self.__ref_vis_objects[ref_vis_obj]
        vis_objects_list = [self.__ref_vis_objects[vis]["object"] for vis in self.__ref_vis_objects]
        real_ref_obj_types = [obj_ref_types[ref_obj] for ref_obj in obj_ref_types]
        for vis_obj in self.vis_objects:
            if vis_obj not in vis_objects_list:
                if type(vis_obj) in real_ref_obj_types:
                    self.remove_vis_object(vis_obj)

    def set_init_ref_obj_vis_properties(self, obj_name, ref_type):
        self.__ref_vis_objects[obj_name]["object"].name = obj_name
        if ref_type == "box":
            self.__ref_vis_objects[obj_name]["object"].center_x = self._object_refinements[obj_name]["centre"][0]
            self.__ref_vis_objects[obj_name]["object"].center_y = self._object_refinements[obj_name]["centre"][1]
            self.__ref_vis_objects[obj_name]["object"].center_z = self._object_refinements[obj_name]["centre"][2]

            self.__ref_vis_objects[obj_name]["object"].x_length = self._object_refinements[obj_name]["lengthX"]
            self.__ref_vis_objects[obj_name]["object"].y_length = self._object_refinements[obj_name]["lengthY"]
            self.__ref_vis_objects[obj_name]["object"].z_length = self._object_refinements[obj_name]["lengthZ"]

        if ref_type == "sphere":
            self.__ref_vis_objects[obj_name]["object"].x = self._object_refinements[obj_name]["centre"][0]
            self.__ref_vis_objects[obj_name]["object"].y = self._object_refinements[obj_name]["centre"][1]
            self.__ref_vis_objects[obj_name]["object"].z = self._object_refinements[obj_name]["centre"][2]

            self.__ref_vis_objects[obj_name]["object"].radius = self._object_refinements[obj_name]["radius"]

        if ref_type == "cone":
            self.__ref_vis_objects[obj_name]["object"].point1_x = self._object_refinements[obj_name]["p0"][0]
            self.__ref_vis_objects[obj_name]["object"].point1_y = self._object_refinements[obj_name]["p0"][1]
            self.__ref_vis_objects[obj_name]["object"].point1_z = self._object_refinements[obj_name]["p0"][2]

            self.__ref_vis_objects[obj_name]["object"].point2_x = self._object_refinements[obj_name]["p1"][0]
            self.__ref_vis_objects[obj_name]["object"].point2_y = self._object_refinements[obj_name]["p1"][1]
            self.__ref_vis_objects[obj_name]["object"].point2_z = self._object_refinements[obj_name]["p1"][2]

            self.__ref_vis_objects[obj_name]["object"].radius1 = self._object_refinements[obj_name]["radius0"]
            self.__ref_vis_objects[obj_name]["object"].radius2 = self._object_refinements[obj_name]["radius1"]

        if ref_type == "line":
            self.__ref_vis_objects[obj_name]["object"].point1_x = self._object_refinements[obj_name]["p0"][0]
            self.__ref_vis_objects[obj_name]["object"].point1_y = self._object_refinements[obj_name]["p0"][1]
            self.__ref_vis_objects[obj_name]["object"].point1_z = self._object_refinements[obj_name]["p0"][2]

            self.__ref_vis_objects[obj_name]["object"].point2_x = self._object_refinements[obj_name]["p1"][0]
            self.__ref_vis_objects[obj_name]["object"].point2_y = self._object_refinements[obj_name]["p1"][1]
            self.__ref_vis_objects[obj_name]["object"].point2_z = self._object_refinements[obj_name]["p1"][2]

    def set_ref_obj_vis_properties(self, var_path, value):
        ref_type = self.get_value_by_path(self._object_refinements, [var_path[1], "type"])
        if ref_type == "box":
            if var_path[-2] == "centre":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].center_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].center_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].center_z = value
            if var_path[-1] == "lengthX":
                self.__ref_vis_objects[var_path[1]]["object"].x_length = value
            if var_path[-1] == "lengthY":
                self.__ref_vis_objects[var_path[1]]["object"].y_length = value
            if var_path[-1] == "lengthZ":
                self.__ref_vis_objects[var_path[1]]["object"].z_length = value

        if ref_type == "sphere":
            if var_path[-2] == "centre":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].z = value
            if var_path[-1] == "radius":
                self.__ref_vis_objects[var_path[1]]["object"].radius = value

        if ref_type == "cone":
            if var_path[-2] == "p0":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_z = value
            if var_path[-2] == "p1":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_z = value
            if var_path[-1] == "radius0":
                self.__ref_vis_objects[var_path[1]]["object"].radius1 = value
            if var_path[-1] == "radius1":
                self.__ref_vis_objects[var_path[1]]["object"].radius2 = value

        if ref_type == "line":
            if var_path[-2] == "p0":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point1_z = value
            if var_path[-2] == "p1":
                if var_path[-1] == "0":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_x = value
                if var_path[-1] == "1":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_y = value
                if var_path[-1] == "2":
                    self.__ref_vis_objects[var_path[1]]["object"].point2_z = value

