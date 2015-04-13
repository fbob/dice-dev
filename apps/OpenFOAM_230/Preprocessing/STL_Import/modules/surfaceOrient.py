"""
surfaceOrient - Utility
=======================
Set normal consistent with respect to a user provided ’outside’ point. If the -inside is used the point is considered
inside.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""


class SurfaceOrient:

    def __init__(self):
        self.point = [100, 100, 100]

    def surface_orient(self, filename, option):
        """
        Calls the run function for surfaceOrient dependent on selected file.
        :param filename: fileindex
        :param option: option argument for surfaceOrient
        :return:
        """
        self.add_cmd_to_history("surface_orient", {"filename": filename, "option":option, "point":self.point})
        self.run_surface_orient(filename, option, self.point)

    def run_surface_orient(self, filename, option, point):
        """
        Call OpenFOAM surfaceOrient utility.
        :param filename:
        :return:
        """
        point_vector = "(" +  str(point[0]) + " " + str(point[1]) + " " + str(point[2]) + ")"
        file_path = self.current_run_path("files", filename)
        if option == "":
            self.foam_exec(["surfaceOrient", file_path, point_vector, file_path], stdout=self.__parse_surface_orient)
        else:
            self.foam_exec(["surfaceOrient", file_path, point_vector, option, file_path], stdout=self.__parse_surface_orient)
        self.update_changed_stl_file(filename)

    def __parse_surface_orient(self, line):
        s_line = line.strip()
        if s_line.startswith("--> FOAM Warning :"):
            line  = "<b style='color: red;font-size: 16px'>"+line+"</b>"
        elif s_line.startswith("Did not flip orientation"):
            line = "<b style='color: #E74700; font-size: 16px'>"+line+"</b>"

        self.read_process_line(line)

    def set_surface_orient_point(self, coordinate, value):
        """
        Set coordinates of the point.
        :param coordinate:
        :param value:
        :return:
        """
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