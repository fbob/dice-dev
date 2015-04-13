"""
Background Mesh with BlockMesh:
===============================
Module to create a bounding box for snappyHexMesh
"""

# External modules
# ================
from PyQt5.QtCore import pyqtSignal, pyqtSlot

# DICE modules
# ============
from core.dice.vis import *
from core.foam.boundary_types import *


class BoundingBox():

    def __init__(self):

        self.__cell_size = {}
        self.__bm_vertices = None
        self.__bm_blocks = None
        self.__bm_boundary = None

        self.__bm_vis = None
        self.__box_vis = None
        self.cylinder = None
        self.cone = None
        self.plane = None

    def bounding_box_load(self):
        self.__bm_vertices = self._block_mesh_dict["vertices"]
        self.__bm_blocks = self._block_mesh_dict["blocks"]
        self.__bm_boundary = self._block_mesh_dict["boundary"]

        # Load box in vis
        self.__bm_vis = MultiPatchBoxWrapper()
        self.__bm_vis.name = "Bounding Box"
        self.add_vis_object(self.__bm_vis)

        self.__cell_size = {
            "0": self.calculate_cell_size("0", self.get_n_cells("0")),
            "1": self.calculate_cell_size("1", self.get_n_cells("1")),
            "2": self.calculate_cell_size("2", self.get_n_cells("2"))
        }

        self.__bm_vis.min_x = self.get_bounding_box_min("0")
        self.__bm_vis.min_y = self.get_bounding_box_min("1")
        self.__bm_vis.min_z = self.get_bounding_box_min("2")

        self.__bm_vis.max_x = self.get_bounding_box_max("0")
        self.__bm_vis.max_y = self.get_bounding_box_max("1")
        self.__bm_vis.max_z = self.get_bounding_box_max("2")

        self.__bm_vis.resolution_x = self.get_n_cells("0")
        self.__bm_vis.resolution_y = self.get_n_cells("1")
        self.__bm_vis.resolution_z = self.get_n_cells("2")

    '''
    Min Vector for the Bounding Box
    ===============================
    '''
    def get_bounding_box_min(self, coordinate):
        return float(self.__bm_vertices[0][int(coordinate)])

    def set_bounding_box_min(self, coordinate, value):
        if value == "$invalid$":
            return
        if coordinate == "0":
            self.__bm_vertices[0][0] = value
            self.__bm_vertices[3][0] = value
            self.__bm_vertices[4][0] = value
            self.__bm_vertices[7][0] = value
            self.__bm_vis.min_x = value
        elif coordinate == "1":
            self.__bm_vertices[0][1] = value
            self.__bm_vertices[1][1] = value
            self.__bm_vertices[4][1] = value
            self.__bm_vertices[5][1] = value
            self.__bm_vis.min_y = value
        elif coordinate == "2":
            self.__bm_vertices[0][2] = value
            self.__bm_vertices[1][2] = value
            self.__bm_vertices[2][2] = value
            self.__bm_vertices[3][2] = value
            self.__bm_vis.min_z = value
        if self.config["blockMesh"]["useCellSize"]:
            cell_size = self.get_cell_size(coordinate)
            n_cells = self.calculate_n_cells(coordinate, cell_size)
            self.set_n_cells(coordinate, n_cells)
        else:
            n_cells = self.get_n_cells(coordinate)
            cell_size = self.calculate_cell_size(coordinate, n_cells)
            self.set_cell_size(coordinate, cell_size)
        self._block_mesh_dict.writeFile()
        self.signal(self.bounding_box_min_signal_name())

    def bounding_box_min_signal_name(self, coordinate=None):
        return "constant/polyMesh/blockMeshDict"

    '''
    MaxVector for the Bounding Box
    ===============================
    '''
    def get_bounding_box_max(self, coordinate):
        return float(self.__bm_vertices[6][int(coordinate)])

    def set_bounding_box_max(self, coordinate, value):
        if value == "$invalid$":
            return
        if coordinate == "0":
            self.__bm_vertices[1][0] = value
            self.__bm_vertices[2][0] = value
            self.__bm_vertices[5][0] = value
            self.__bm_vertices[6][0] = value
            self.__bm_vis.max_x = value
        elif coordinate == "1":
            self.__bm_vertices[2][1] = value
            self.__bm_vertices[3][1] = value
            self.__bm_vertices[6][1] = value
            self.__bm_vertices[7][1] = value
            self.__bm_vis.max_y = value
        elif coordinate == "2":
            self.__bm_vertices[4][2] = value
            self.__bm_vertices[5][2] = value
            self.__bm_vertices[6][2] = value
            self.__bm_vertices[7][2] = value
            self.__bm_vis.max_z = value
        if self.config["blockMesh"]["useCellSize"]:
            cell_size = self.get_cell_size(coordinate)
            n_cells = self.calculate_n_cells(coordinate, cell_size)
            self.set_n_cells(coordinate, n_cells)
        else:
            n_cells = self.get_n_cells(coordinate)
            cell_size = self.calculate_cell_size(coordinate, n_cells)
            self.set_cell_size(coordinate, cell_size)
        self._block_mesh_dict.writeFile()
        self.signal(self.bounding_box_max_signal_name())

    def bounding_box_max_signal_name(self, coordinate=None):
        return "constant/polyMesh/blockMeshDict"

    '''
    Spacing values
    ==============
    '''
    def get_spacing(self, coordinate):
        if coordinate == "0":
            return self.config["blockMesh"]["spacingX"]
        elif coordinate == "1":
            return self.config["blockMesh"]["spacingY"]
        elif coordinate == "2":
            return self.config["blockMesh"]["spacingZ"]

    def set_spacing(self, coordinate, value):
        if coordinate == "0":
            self.config["blockMesh"]["spacingX"] = value
        elif coordinate == "1":
            self.config["blockMesh"]["spacingY"] = value
        elif coordinate == "2":
            self.config["blockMesh"]["spacingZ"] = value
        self.config.write()


    def spacing_signal_name(self, coordinate=None):
        return "app.dice"

    def set_additional_spacing(self):
        spacing_x = float(self.get_spacing("0"))/100
        spacing_y = float(self.get_spacing("1"))/100
        spacing_z = float(self.get_spacing("2"))/100
        min_x = self.get_bounding_box_min("0")
        min_y = self.get_bounding_box_min("1")
        min_z = self.get_bounding_box_min("2")

        max_x = self.get_bounding_box_max("0")
        max_y = self.get_bounding_box_max("1")
        max_z = self.get_bounding_box_max("2")

        delta_x = max_x - min_x
        delta_y = max_y - min_y
        delta_z = max_z - min_z

        self.__bm_vis.min_x = round(min_x - delta_x * spacing_x, 4)
        self.__bm_vis.min_y = round(min_y - delta_y * spacing_y, 4)
        self.__bm_vis.min_z = round(min_z - delta_z * spacing_z, 4)

        self.__bm_vis.max_x = round(max_x + delta_x * spacing_x, 4)
        self.__bm_vis.max_y = round(max_y + delta_y * spacing_y, 4)
        self.__bm_vis.max_z = round(max_z + delta_z * spacing_z, 4)

        # update file
        self.set_bounding_box_min("0", self.__bm_vis.min_x)
        self.set_bounding_box_min("1", self.__bm_vis.min_y)
        self.set_bounding_box_min("2", self.__bm_vis.min_z)

        self.set_bounding_box_max("0", self.__bm_vis.max_x)
        self.set_bounding_box_max("1", self.__bm_vis.max_y)
        self.set_bounding_box_max("2", self.__bm_vis.max_z)

        self.signal(self.bounding_box_min_signal_name())
        self.signal(self.bounding_box_max_signal_name())

    '''
    Functions to calculate number of cells and cell size
    ====================================================
    '''
    def calculate_cell_size(self, coordinate, n_cells):
        min_value = self.get_bounding_box_min(coordinate)
        max_value = self.get_bounding_box_max(coordinate)
        try:
            cell_size = (max_value - min_value)/n_cells
        except ZeroDivisionError:
            cell_size = 0
        return round(cell_size, 4)

    def calculate_n_cells(self, coordinate, cell_size):
        min_value = self.get_bounding_box_min(coordinate)
        max_value = self.get_bounding_box_max(coordinate)
        try:
            n_cells = (max_value - min_value)/cell_size
        except ZeroDivisionError:
            n_cells = 0
        return int(round(n_cells, 0))

    def get_n_cells(self, coordinate):
        return int(self.__bm_blocks[2][int(coordinate)])

    def set_n_cells(self, coordinate, value):
        coordinate = int(coordinate)
        self.__bm_blocks[2][coordinate] = value
        self._block_mesh_dict.writeFile()
        self.signal(self.cell_size_signal_name())

        if coordinate == 0:
            self.__bm_vis.resolution_x = value
        elif coordinate == 1:
            self.__bm_vis.resolution_y = value
        elif coordinate == 2:
            self.__bm_vis.resolution_z = value

    def n_cells_signal_name(self, coordinate=None):
        return "constant/polyMesh/blockMeshDict"

    def get_cell_size(self, coordinate):
        if not self.config["blockMesh"]["useCellSize"]:
            n_cells = self.get_n_cells(coordinate)
            self.__cell_size[coordinate] = self.calculate_cell_size(coordinate, n_cells)
        return self.__cell_size[coordinate]

    def set_cell_size(self, coordinate, value):
        self.__cell_size[coordinate] = value
        if self.config["blockMesh"]["useCellSize"]:
            self.set_n_cells(coordinate, self.calculate_n_cells(coordinate, value))
            self.signal(self.n_cells_signal_name())

    def cell_size_signal_name(self, coordinate=None):
        return "constant/polyMesh/blockMeshDict"

    '''
    Calculate bounding box automatically
    ====================================
    '''
    def calculate_bounding_box(self):
        if self._input_files:
            min_x = min([min([region["min"][0] for region in stl.patchInfo()]) for stl in self._input_files])
            min_y = min([min([region["min"][1] for region in stl.patchInfo()]) for stl in self._input_files])
            min_z = min([min([region["min"][2] for region in stl.patchInfo()]) for stl in self._input_files])
            max_x = max([max([region["max"][0] for region in stl.patchInfo()]) for stl in self._input_files])
            max_y = max([max([region["max"][1] for region in stl.patchInfo()]) for stl in self._input_files])
            max_z = max([max([region["max"][2] for region in stl.patchInfo()]) for stl in self._input_files])

            # update file
            self.set_bounding_box_min("0", min_x)
            self.set_bounding_box_min("1", min_y)
            self.set_bounding_box_min("2", min_z)

            self.set_bounding_box_max("0", max_x)
            self.set_bounding_box_max("1", max_y)
            self.set_bounding_box_max("2", max_z)

            self.signal(self.bounding_box_min_signal_name())
            self.signal(self.bounding_box_max_signal_name())

            self.set_additional_spacing()

            return [min_x, min_y, min_z, max_x, max_y, max_z]
        else:
            pass

    '''
    BlockMesh boundary patches
    ==========================
    '''
    def get_boundaries(self):
        boundary_names = []
        for i, boundary in enumerate(self.__bm_boundary):
            if type(boundary) == str:
                boundary_names.append(
                    {
                        "text": boundary,
                        "index": i+1
                    }
                )
        return boundary_names

    boundaries_changed = pyqtSignal(name="boundariesChanged")

    def boundary_types(self):
        return boundary_types()