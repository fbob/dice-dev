"""
surfaceCoarsen - Utility
==========================
Surface coarsening using ’bunnylod’.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""
import os


class SurfaceCoarsen:

    def __init__(self):
        self.reduction_factor = 1.0

    def surface_coarsen(self, filename):
        relative_file_path = "files/{0}".format(filename)
        self.add_cmd_to_history("surface_coarsen", {"relative_file_path": relative_file_path, "reduction_factor": self.reduction_factor})
        self.run_surface_coarsen(relative_file_path, self.reduction_factor)

    def run_surface_coarsen(self, relative_file_path, reduction_factor):
        full_file_path = self.current_run_path(relative_file_path)
        filename = os.path.basename(full_file_path)
        self.foam_exec(["surfaceCoarsen", full_file_path, str(reduction_factor), full_file_path])

        self.update_changed_stl_file(filename)

    def set_surface_coarsen_reduction_factor(self, value):
        """
        Set reduction factor.
        :param value:
        :return:
        """
        self.reduction_factor = value

    def get_surface_coarsen_reduction_factor(self, *args):
        return self.reduction_factor

    def surface_coarsen_reduction_factor_signal_name(self, coordinate=None):
        return ""