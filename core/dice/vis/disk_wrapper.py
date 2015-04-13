# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class DiskWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(DiskWrapper, self).__init__(parent)

        self.name = "Disk"
        self.__x = 0
        self.__y = 0
        self.__z = 0
        self.__norm_x = 0
        self.__norm_y = 0
        self.__norm_z = 1
        self.__radius = 1.0
        self._visible = True

    '''
    Actor origin (x, y, z)
    ======================
    '''
    # x-coordinate
    # ============
    x_changed = pyqtSignal(name="XChanged")

    @property
    def x(self):
        return float(self.__x)

    @x.setter
    def x(self, x):
        if self.__x != x:
            self.__x = x
            self.x_changed.emit()
            self.invoke("setX", x, float)

    x = pyqtProperty(float, fget=x.fget, fset=x.fset, notify=x_changed)

    # y-coordinate
    # ============
    y_changed = pyqtSignal(name="yChanged")

    @property
    def y(self):
        return self.__y

    @y.setter
    def y(self, y):
        if self.__y != y:
            self.__y = y
            self.y_changed.emit()
            self.invoke("setY", y, float)

    y = pyqtProperty(float, fget=y.fget, fset=y.fset, notify=y_changed)

    # z-coordinate
    # ============
    z_changed = pyqtSignal(name="zChanged")

    @property
    def z(self):
        return self.__z

    @z.setter
    def z(self, z):
        if self.__z != z:
            self.__z = z
            self.z_changed.emit()
            self.invoke("setZ", z, float)

    z = pyqtProperty(float, fget=z.fget, fset=z.fset, notify=z_changed)

    '''
    Normal vector
    =============
    '''
    # x-component
    # ===========
    norm_x_changed = pyqtSignal(name="normXChanged")

    @property
    def norm_x(self):
        return float(self.__norm_x)

    @norm_x.setter
    def norm_x(self, norm_x):
        if self.__norm_x != norm_x:
            self.__norm_x = norm_x
            self.norm_x_changed.emit()
            self.invoke("setNormX", norm_x, float)

    normX = pyqtProperty(float, fget=norm_x.fget, fset=norm_x.fset, notify=norm_x_changed)

    # y-component
    # ===========
    norm_y_changed = pyqtSignal(name="normYChanged")

    @property
    def norm_y(self):
        return float(self.__norm_y)

    @norm_y.setter
    def norm_y(self, norm_y):
        if self.__norm_y != norm_y:
            self.__norm_y = norm_y
            self.norm_y_changed.emit()
            self.invoke("setNormY", norm_y, float)

    normY = pyqtProperty(float, fget=norm_y.fget, fset=norm_y.fset, notify=norm_y_changed)

    # z-component
    # ===========
    norm_z_changed = pyqtSignal(name="normZChanged")

    @property
    def norm_z(self):
        return float(self.__norm_z)

    @norm_z.setter
    def norm_z(self, norm_z):
        if self.__norm_z != norm_z:
            self.__norm_z = norm_z
            self.norm_z_changed.emit()
            self.invoke("setNormZ", norm_z, float)

    normZ = pyqtProperty(float, fget=norm_z.fget, fset=norm_z.fset, notify=norm_z_changed)

    '''
    Radius
    ======
    '''
    radius_changed = pyqtSignal(name="radiusChanged")

    @property
    def radius(self):
        return float(self.__radius)

    @radius.setter
    def radius(self, radius):
        if self.__radius != radius:
            self.__radius = radius
            self.radius_changed.emit()
            self.invoke("setRadius", radius, float)

    radius = pyqtProperty(str, fget=radius.fget, fset=radius.fset, notify=radius_changed)
