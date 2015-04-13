"""
surfaceAutoPatch - Utility
==========================
Patches surface according to feature angle.
(src: http://www.openfoam.org/docs/user/standard-utilities.php)
"""
import os


class SurfaceAutoPatch:

    def __init__(self):
        self.feature_angle = 0

    def surface_auto_patch(self, filename):
        """
        Calls the run function for surfaceAutoPatch dependent on selected file
        :param filename:
        :return:
        """
        file_path = "files/{0}".format(filename)
        self.add_cmd_to_history("surface_auto_patch", {"relative_file_path": file_path, "feature_angle": self.feature_angle})
        self.run_surface_auto_patch(file_path, self.feature_angle)

    def run_surface_auto_patch(self, relative_file_path, feature_angle):
        """
        Call OpenFOAM surfaceAutoPatch utility
        :param relative_file_path:
        :param feature_angle:
        :return:
        """
        full_file_path = self.current_run_path(relative_file_path)
        filename = os.path.basename(full_file_path)
        self.foam_exec(["surfaceAutoPatch", full_file_path, full_file_path, str(feature_angle)])

        self.update_changed_stl_file(filename)

    def set_surface_auto_patch_angle(self, value):
        """
        Set feature angle.
        :param value:
        :return:
        """
        self.feature_angle = value

    def get_surface_auto_patch_angle(self, *args):
        return self.feature_angle

    def surface_auto_patch_angle_signal_name(self):
        return ""