"""
surfaceCheck - Utility
======================
Checking geometric and topological quality of a surface.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""


class SurfaceCheck:

    def surface_check(self, filename):
        # filename = self.object_files[index]["file_path"]
        self.add_cmd_to_history("surface_check", {"filename": filename})
        self.run_surface_check(filename)

    def run_surface_check(self, filename):
        """
        Runs surfaceCheck and parses for no illegal surfaces and that the surface is closed;
        :param filename:
        :return:
        """
        file_path = self.current_run_path("files", filename)
        self.foam_exec(["surfaceCheck", file_path], stdout=self.__parse_surface_check)

    def __parse_surface_check(self, line):
        s_line = line.strip()
        if s_line == "Surface has no illegal triangles.":
            line = "<b style='color: green; font-size: 16px'>"+line+"</b>"
        elif s_line.startswith("Surface is closed."):
            line = "<b style='color: green; font-size: 16px'>"+line+"</b>"
        elif s_line.startswith("--> FOAM Warning :"):
            line  = "<b style='color: red;font-size: 16px'>"+line+"</b>"

        self.read_process_line(line)
