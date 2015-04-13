# External modules
# ================
from PyQt5.QtCore import pyqtProperty, pyqtSignal

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class BoxWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(BoxWrapper, self).__init__(parent)

        self.name = "Box"

        self.__min_x = 0.0
        self.__max_x = 1.0

        self.__min_y = 0.0
        self.__max_y = 1.0

        self.__min_z = 0.0
        self.__max_z = 1.0

        self.__center_x = None
        self.__center_y = None
        self.__center_z = None

        self.__x_length = None
        self.__y_length = None
        self.__z_length = None

    min_x_changed = pyqtSignal(float, name="minXChanged")

    @property
    def min_x(self):
        return float(self.__min_x)

    @min_x.setter
    def min_x(self, min_x):
        if self.__min_x != min_x:
            self.__min_x = min_x
            self.min_x_changed.emit(self.__min_x)
            self.invoke("setMinX", min_x, float)

    minX = pyqtProperty(float, fget=min_x.fget, fset=min_x.fset, notify=min_x_changed)

    max_x_changed = pyqtSignal(float, name="maxXChanged")

    @property
    def max_x(self):
        return float(self.__max_x)

    @max_x.setter
    def max_x(self, max_x):
        if self.__max_x != max_x:
            self.__max_x = max_x
            self.max_x_changed.emit(self.__max_x)
            self.invoke("setMaxX", max_x, float)

    maxX = pyqtProperty(float, fget=max_x.fget, fset=max_x.fset, notify=max_x_changed)

    min_y_changed = pyqtSignal(float, name="minYChanged")

    @property
    def min_y(self):
        return float(self.__min_y)

    @min_y.setter
    def min_y(self, min_y):
        if self.__min_y != min_y:
            self.__min_y = min_y
            self.min_y_changed.emit(self.__min_y)
            self.invoke("setMinY", min_y, float)

    minY = pyqtProperty(float, fget=min_y.fget, fset=min_y.fset, notify=min_y_changed)

    max_y_changed = pyqtSignal(float, name="maxYChanged")

    @property
    def max_y(self):
        return float(self.__max_y)

    @max_y.setter
    def max_y(self, max_y):
        if self.__max_y != max_y:
            self.__max_y = max_y
            self.max_y_changed.emit(self.__max_y)
            self.invoke("setMaxY", max_y, float)

    maxY = pyqtProperty(float, fget=max_y.fget, fset=max_y.fset, notify=max_y_changed)

    min_z_changed = pyqtSignal(float, name="minZChanged")

    @property
    def min_z(self):
        return float(self.__min_z)

    @min_z.setter
    def min_z(self, min_z):
        if self.__min_z != min_z:
            self.__min_z = min_z
            self.min_z_changed.emit(self.__min_z)
            self.invoke("setMinZ", min_z, float)

    minZ = pyqtProperty(float, fget=min_z.fget, fset=min_z.fset, notify=min_z_changed)

    max_z_changed = pyqtSignal(float, name="maxZChanged")

    @property
    def max_z(self):
        return float(self.__max_z)

    @max_z.setter
    def max_z(self, max_z):
        if self.__max_z != max_z:
            self.__max_z = max_z
            self.max_z_changed.emit(self.__max_z)
            self.invoke("setMaxZ", max_z, float)

    maxZ = pyqtProperty(float, fget=max_z.fget, fset=max_z.fset, notify=max_z_changed)
    
    center_x_changed = pyqtSignal(name="centerXChanged")
    
    @property
    def center_x(self):
        return float(self.__center_x)
    
    @center_x.setter
    def center_x(self, center_x):
        if self.__center_x != center_x:
            self.__center_x = center_x
            self.center_x_changed.emit()
            self.invoke("setCenterX", center_x, float)
    
    centerX = pyqtProperty(float, fget=center_x.fget, fset=center_x.fset, notify=center_x_changed)

    center_y_changed = pyqtSignal(name="centerYChanged")

    @property
    def center_y(self):
        return float(self.__center_y)

    @center_y.setter
    def center_y(self, center_y):
        if self.__center_y != center_y:
            self.__center_y = center_y
            self.center_y_changed.emit()
            self.invoke("setCenterY", center_y, float)

    centerY = pyqtProperty(float, fget=center_y.fget, fset=center_y.fset, notify=center_y_changed)

    center_z_changed = pyqtSignal(name="centerZChanged")

    @property
    def center_z(self):
        return float(self.__center_z)

    @center_z.setter
    def center_z(self, center_z):
        if self.__center_z != center_z:
            self.__center_z = center_z
            self.center_z_changed.emit()
            self.invoke("setCenterZ", center_z, float)

    centerZ = pyqtProperty(float, fget=center_z.fget, fset=center_z.fset, notify=center_z_changed)

    x_length_changed = pyqtSignal(name="xLengthChanged")

    @property
    def x_length(self):
        return float(self.__x_length)

    @x_length.setter
    def x_length(self, x_length):
        if self.__x_length != x_length:
            self.__x_length = x_length
            self.x_length_changed.emit()
            self.invoke("setXLength", x_length, float)

    xLength = pyqtProperty(float, fget=x_length.fget, fset=x_length.fset, notify=x_length_changed)

    y_length_changed = pyqtSignal(name="yLengthChanged")

    @property
    def y_length(self):
        return float(self.__y_length)

    @y_length.setter
    def y_length(self, y_length):
        if self.__y_length != y_length:
            self.__y_length = y_length
            self.y_length_changed.emit()
            self.invoke("setYLength", y_length, float)

    yLength = pyqtProperty(float, fget=y_length.fget, fset=y_length.fset, notify=y_length_changed)

    z_length_changed = pyqtSignal(name="zLengthChanged")

    @property
    def z_length(self):
        return float(self.__z_length)

    @z_length.setter
    def z_length(self, z_length):
        if self.__z_length != z_length:
            self.__z_length = z_length
            self.z_length_changed.emit()
            self.invoke("setZLength", z_length, float)

    zLength = pyqtProperty(float, fget=z_length.fget, fset=z_length.fset, notify=z_length_changed)
