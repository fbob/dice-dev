"""
surfaceRefineRedGreen - Utility
==========================
Refine by splitting all three edges of triangle (’red’ refinement).
Neighbouring triangles (which are not marked for refinement get split in half (’green’ refinement).
(R. Verfuerth, ”A review of a posteriori error estimation and adaptive mesh refinement techniques”, Wiley-Teubner, 1996)
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""

class SurfaceRefineRedGreen:

    def surface_refine_red_green(self, filename):
        self.add_cmd_to_history("surface_refine_red_green", {"filename": filename})
        self.run_surface_refine_red_green(filename)

    def run_surface_refine_red_green(self, filename):
        file_path = self.current_run_path("files", filename)
        self.foam_exec(["surfaceRefineRedGreen", file_path, file_path])

        self.update_changed_stl_file(filename)

