"""
surfaceMeshInfo - Utility
=========================
Miscellaneous information about surface meshes.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""


class SurfaceMeshInfo:

    def surface_mesh_info(self, filename):
        self.add_cmd_to_history("surface_mesh_info", {"filename": filename})
        self.run_surface_mesh_info(filename)

    def run_surface_mesh_info(self, filename):
        file_path = self.current_run_path("files", filename)
        self.foam_exec(["surfaceMeshInfo", file_path])