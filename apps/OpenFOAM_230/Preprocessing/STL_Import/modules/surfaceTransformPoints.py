"""
surfaceTransformPoints - Utility
================================
Transform (scale/rotate) a surface. Like transformPoints but for surfaces.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""


class SurfaceTransformPoints:

    def __init__(self):
        self.vector = [0, 0, 0]
        self.vector_2 = [0, 0, 0]

    def surface_transform_points(self, filename, option):
        """
        Calls the run function for surfaceTransformPoints dependent on selected file
        :param filename:
        :param option:
        :return:
        """
        if option == "-rotate":
            self.add_cmd_to_history("surface_transform_points", {"filename": filename, "option":option,
                                                             "vector":self.vector, "vector_2":self.vector_2})
        else:
            self.add_cmd_to_history("surface_transform_points", {"filename": filename, "option":option,
                                                             "vector":self.vector})
        self.run_surface_transform_points(filename, option, vector = self.vector, vector_2 = self.vector_2)

    def run_surface_transform_points(self, filename, option, **kwargs):
        """
        Call OpenFOAM surfaceTransformPoints utility
        :param filename:
        :param option:
        :return:
        """
        if option == "-rotate":
            vector = "(" \
                     + "(" +  str(kwargs["vector"][0]) + " " + str(kwargs["vector"][1]) + " " + str(kwargs["vector"][2]) + ")" \
                     + "(" +  str(kwargs["vector_2"][0]) + " " + str(kwargs["vector_2"][1]) + " " + str(kwargs["vector_2"][2]) + ")" \
                     + ")"
        else:
            vector = "(" +  str(kwargs["vector"][0]) + " " + str(kwargs["vector"][1]) + " " + str(kwargs["vector"][2]) + ")"
        file_path = self.current_run_path("files", filename)
        self.foam_exec(["surfaceTransformPoints", file_path, option, vector, file_path], stdout=self.__parse_surface_transform_points)

        self.update_changed_stl_file(filename)

    def __parse_surface_transform_points(self, line):
        s_line = line.strip()
        if s_line.startswith("--> FOAM Warning :"):
            line  = "<b style='color: red;font-size: 16px'>"+line+"</b>"
        elif s_line.startswith("Did not flip orientation"):
            line = "<b style='color: #E74700; font-size: 16px'>"+line+"</b>"

        self.read_process_line(line)

    def set_surface_transform_points_vector(self, coordinate, value):
        """
        Set coordinates of the point.
        :param coordinate:
        :param value:
        :return:
        """
        self.vector[int(coordinate)] = value

    def get_surface_transform_points_vector(self, coordinate):
        return self.vector[int(coordinate)]

    def surface_transform_points_vector_signal_name(self, coordinate=None):
        return ""

    def set_surface_transform_points_vector_2(self, coordinate, value):
        """
        Set coordinates of the point.
        :param coordinate:
        :param value:
        :return:
        """
        self.vector_2[int(coordinate)] = value

    def get_surface_transform_points_vector_2(self, coordinate):
        return self.vector_2[int(coordinate)]

    def surface_transform_points_vector_2_signal_name(self, coordinate=None):
        return ""