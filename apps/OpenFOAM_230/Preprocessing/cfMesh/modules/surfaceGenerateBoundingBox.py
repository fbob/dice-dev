"""
surfaceGenerateBoundingBox - Utility
====================================
Creates a box with offset around the stl geometry.
"""


class SurfaceGenerateBoundingBox:

    # def __init__(self):
    #     self.__x_neg = 0
    #     self.__y_neg = 0
    #     self.__z_neg = 0
    #     self.__x_pos = 0
    #     self.__y_pos = 0
    #     self.__z_pos = 0

    def generate_surface_box(self, input_filename, output_filename, x_neg, x_pos, y_neg, y_pos, z_neg, z_pos):
        input_file_path = self.current_run_path("constant", "triSurface", input_filename)
        output_file_path = self.current_run_path("constant", "triSurface", output_filename)
        self.foam_exec(["surfaceGenerateBoundingBox", input_file_path, output_file_path, x_neg, x_pos, y_neg, y_pos, z_neg, z_pos])
