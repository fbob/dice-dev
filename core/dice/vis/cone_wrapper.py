# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class ConeWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(ConeWrapper, self).__init__(parent)

        self.name = "Cone"
        self.__x = 0
        self.__y = 0
        self.__z = 0
        self.__radius = 0.5
        self.__height = 1.0
        self.__direction_x = 1
        self.__direction_y = 0
        self.__direction_z = 0
        self._visible = True

    '''
    Centre (x, y, z)
    ================
    '''
    # x-coordinate
    # ============
    x_changed = pyqtSignal(name="xChanged")

    @pyqtProperty(float, notify=x_changed)
    def x(self):
        return self.__x

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
        return self.__y

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
        return self.__z

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

    @pyqtProperty(float, notify=radius_changed)
    def radius(self):
        return self.__radius

    @radius.setter
    def radius(self, radius):
        if self.__radius != radius:
            self.__radius = radius
            self.radius_changed.emit()
            self.invoke("setRadius", radius, float)

    '''
    Height
    ======
    '''
    height_changed = pyqtSignal(name="heightChanged")

    @pyqtProperty(float, notify=height_changed)
    def height(self):
        return self.__height

    @height.setter
    def height(self, height):
        if self.__height != height:
            self.__height = height
            self.height_changed.emit()
            self.invoke("setHeight", height, float)

    '''
    Direction vector (x, y, z)
    ==========================
    '''
    # x-direction
    # ===========
    direction_x_changed = pyqtSignal(name="directionXChanged")

    @property
    def direction_x(self):
        return self.__direction_x

    @direction_x.setter
    def direction_x(self, direction_x):
        if self.__direction_x != direction_x:
            self.__direction_x = direction_x
            self.direction_x_changed.emit()
            self.invoke("setDirectionX", direction_x, float)

    # y-direction
    # ===========
    direction_y_changed = pyqtSignal(name="directionYChanged")

    @property
    def direction_y(self):
        return self.__direction_y

    @direction_y.setter
    def direction_y(self, direction_y):
        if self.__direction_y != direction_y:
            self.__direction_y = direction_y
            self.direction_y_changed.emit()
            self.invoke("setDirectionY", direction_y, float)

    # z-direction
    # ===========
    direction_z_changed = pyqtSignal(name="directionZChanged")

    @property
    def direction_z(self):
        return self.__direction_z

    @direction_z.setter
    def direction_z(self, direction_z):
        if self.__direction_z != direction_z:
            self.__direction_z = direction_z
            self.direction_z_changed.emit()
            self.invoke("setDirectionZ", direction_z, float)

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
