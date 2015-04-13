# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class SphereWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(SphereWrapper, self).__init__(parent)

        self.name = "Sphere"
        self.__x = 0.0
        self.__y = 0.0
        self.__z = 0.0
        self.__radius = 1
        self._visible = True

    '''
    Actor origin (x, y, z)
    ======================
    '''
    # x-coordinate
    # ============
    x_changed = pyqtSignal(name="xChanged")

    @pyqtProperty(float, notify=x_changed)
    def x(self):
        return float(self.__x)

    @x.setter
    def x(self, x):
        if self.__x != x:
            self.__x = x
            self.x_changed.emit()
            self.invoke("setX", x, float)

    # y-coordinate
    # ============
    y_changed = pyqtSignal(name="yChanged")

    @pyqtProperty(float, notify=y_changed)
    def y(self):
        return float(self.__y)

    @y.setter
    def y(self, y):
        if self.__y != y:
            self.__y = y
            self.y_changed.emit()
            self.invoke("setY", y, float)

    # z-coordinate
    # ============
    z_changed = pyqtSignal(name="zChanged")

    @pyqtProperty(float, notify=z_changed)
    def z(self):
        return float(self.__z)

    @z.setter
    def z(self, z):
        if self.__z != z:
            self.__z = z
            self.z_changed.emit()
            self.invoke("setZ", z, float)

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

    '''
    Visibility
    ==========
    '''
    visible_changed = pyqtSignal(name="visibleChanged")

    @pyqtProperty(bool, notify=visible_changed)
    def visible(self):
        return self._visible

    @visible.setter
    def visible(self, visible):
        if self._visible != visible:
            self._visible = visible
            self.visible_changed.emit()
            self.invoke("setVisible", visible)