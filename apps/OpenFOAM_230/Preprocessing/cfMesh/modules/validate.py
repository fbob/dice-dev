"""
Validator before run
====================
"""


class Validator:

    def validate(self):
        self.check_if_stl_empty()

    def check_if_stl_empty(self):
        if self._mesh_dict["surfaceFile"] != '""':
            return True
        else:
            raise Exception("No stl file! \nPlease check connections.")
