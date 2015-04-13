import os
from PyFoam.RunDictionary.BoundaryDict import BoundaryDict


class FoamMesh:
    def __init__(self, path):
        self.path = path
        self.file_name = os.path.join(path, "foam.view")
        if not os.path.exists(self.file_name):
            self.__create_view_file()

    def __create_view_file(self):
        with open(self.file_name, "w") as f:
            pass
    #
    # def folder_path(self):
    #     return os.path.join(self.path, "constant", "polyMesh")

    def boundary_dict(self):
        return BoundaryDict(self.path)

    def boundary_dict_path(self):
        return BoundaryDict(self.path).realName()

    def boundary_real_name(self):
        return os.path.split(self.boundary_dict_path())[-1]

