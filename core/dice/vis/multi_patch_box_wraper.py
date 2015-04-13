# External modules
# ================
from PyQt5.QtCore import pyqtProperty, pyqtSignal

# DICE modules
# ============
from core.dice.vis import BoxWrapper


class MultiPatchBoxWrapper(BoxWrapper):
    """
    Basically the same as a BoxWrapper. Multiple patches are handled in the C++ code.
    """
    def __init__(self, parent=None):
        super(MultiPatchBoxWrapper, self).__init__(parent)

        self.__resolution_x = 1
        self.__resolution_y = 1
        self.__resolution_z = 1

    resolution_x_changed = pyqtSignal(name="resolutionXChanged")

    @property
    def resolution_x(self):
        return self.__resolution_x

    @resolution_x.setter
    def resolution_x(self, resolution_x):
        if self.__resolution_x != resolution_x:
            self.__resolution_x = resolution_x
            self.resolution_x_changed.emit()
            self.invoke("setResolutionX", resolution_x, int)

    resolutionX = pyqtProperty(int, fget=resolution_x.fget, fset=resolution_x.fset, notify=resolution_x_changed)

    resolution_y_changed = pyqtSignal(name="resolutionYChanged")

    @property
    def resolution_y(self):
        return self.__resolution_y

    @resolution_y.setter
    def resolution_y(self, resolution_y):
        if self.__resolution_y != resolution_y:
            self.__resolution_y = resolution_y
            self.resolution_y_changed.emit()
            self.invoke("setResolutionY", resolution_y, int)

    resolutionY = pyqtProperty(int, fget=resolution_y.fget, fset=resolution_y.fset, notify=resolution_y_changed)

    resolution_z_changed = pyqtSignal(name="resolutionZChanged")

    @property
    def resolution_z(self):
        return self.__resolution_z

    @resolution_z.setter
    def resolution_z(self, resolution_z):
        if self.__resolution_z != resolution_z:
            self.__resolution_z = resolution_z
            self.resolution_z_changed.emit()
            self.invoke("setResolutionZ", resolution_z, int)

    resolutionZ = pyqtProperty(int, fget=resolution_z.fget, fset=resolution_z.fset, notify=resolution_z_changed)