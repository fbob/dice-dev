"""
surfaceSplitByPatch - Utility
==========================
Writes regions of triSurface to separate files
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""

class SurfaceSplitByPatch:

    def surface_split_by_patch(self, filename):
        self.add_cmd_to_history("surface_split_by_patch", {"filename": filename})
        self.run_surface_split_by_patch(filename)

    def run_surface_split_by_patch(self, filename):
        file_path = self.current_run_path("files", filename)
        self.foam_exec(["surfaceSplitByPatch", file_path])
