# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class CylinderWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(CylinderWrapper, self).__init__(parent)

        self.name = "Cylinder"
        self.__x = 0
        self.__y = 0
        self.__z = 0
        self.__radius = 1.0
        self.__height = 10.0
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

    @property
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

    @property
    def height(self):
        return float(self.__height)

    @height.setter
    def height(self, height):
        if self.__height != height:
            self.__height = height
            self.height_changed.emit()
            self.invoke("setHeight", height, float)

    height = pyqtProperty(float, fget=height.fget, fset=height.fset, notify=height_changed)

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

    # '''
    # Point1
    # ======
    # '''
    # # x-coordinate
    # # ============
    # point1_x_changed = pyqtSignal(name="point1XChanged")
    #
    # @property
    # def point1_x(self):
    #     return float(self.__point1_x)
    #
    # @point1_x.setter
    # def point1_x(self, point1_x):
    #     if self.__point1_x != point1_x:
    #         self.__point1_x = point1_x
    #         self.point1_x_changed.emit()
    #
    # point1X = pyqtProperty(float, fget=point1_x.fget, fset=point1_x.fset, notify=point1_x_changed)
    #
    # # y-coordinate
    # # ============
    # point1_y_changed = pyqtSignal(name="point1YChanged")
    #
    # @property
    # def point1_y(self):
    #     return float(self.__point1_y)
    #
    # @point1_y.setter
    # def point1_y(self, point1_y):
    #     if self.__point1_y != point1_y:
    #         self.__point1_y = point1_y
    #         self.point1_y_changed.emit()
    #
    # point1Y = pyqtProperty(float, fget=point1_y.fget, fset=point1_y.fset, notify=point1_y_changed)
    #
    # # z-coordinate
    # # ============
    # point1_z_changed = pyqtSignal(name="point1ZChanged")
    #
    # @property
    # def point1_z(self):
    #     return float(self.__point1_z)
    #
    # @point1_z.setter
    # def point1_z(self, point1_z):
    #     if self.__point1_z != point1_z:
    #         self.__point1_z = point1_z
    #         self.point1_z_changed.emit()
    #
    # point1Z = pyqtProperty(float, fget=point1_z.fget, fset=point1_z.fset, notify=point1_z_changed)
    #
    # '''
    # Point2
    # ======
    # '''
    # # x-coordinate
    # # ============
    # point2_x_changed = pyqtSignal(name="point2XChanged")
    #
    # @property
    # def point2_x(self):
    #     return float(self.__point2_x)
    #
    # @point2_x.setter
    # def point2_x(self, point2_x):
    #     if self.__point2_x != point2_x:
    #         self.__point2_x = point2_x
    #         self.point2_x_changed.emit()
    #
    # point2X = pyqtProperty(float, fget=point2_x.fget, fset=point2_x.fset, notify=point2_x_changed)
    #
    # # y-coordinate
    # # ============
    # point2_y_changed = pyqtSignal(name="point2YChanged")
    #
    # @property
    # def point2_y(self):
    #     return float(self.__point2_y)
    #
    # @point2_y.setter
    # def point2_y(self, point2_y):
    #     if self.__point2_y != point2_y:
    #         self.__point2_y = point2_y
    #         self.point2_y_changed.emit()
    #
    # point2Y = pyqtProperty(float, fget=point2_y.fget, fset=point2_y.fset, notify=point2_y_changed)
    #
    # # z-coordinate
    # # ============
    # point2_z_changed = pyqtSignal(name="point2ZChanged")
    #
    # @property
    # def point2_z(self):
    #     return float(self.__point2_z)
    #
    # @point2_z.setter
    # def point2_z(self, point2_z):
    #     if self.__point2_z != point2_z:
    #         self.__point2_z = point2_z
    #         self.point2_z_changed.emit()
    #
    # point2Z = pyqtProperty(float, fget=point2_z.fget, fset=point2_z.fset, notify=point2_z_changed)
