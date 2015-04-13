# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .basic_wrapper import BasicWrapper


class LineWrapper(BasicWrapper):
    def __init__(self, parent=None):
        super(LineWrapper, self).__init__(parent)

        self.__point1_x = 0.0
        self.__point1_y = 0.0
        self.__point1_z = 0.0

        self.__point2_x = 10.0
        self.__point2_y = 10.0
        self.__point2_z = 10.0

    '''
    Point1
    ======
    '''
    # x-coordinate
    # ============
    point1_x_changed = pyqtSignal(name="point1XChanged")

    @property
    def point1_x(self):
        return float(self.__point1_x)

    @point1_x.setter
    def point1_x(self, point1_x):
        if self.__point1_x != point1_x:
            self.__point1_x = point1_x
            self.point1_x_changed.emit()
            self.invoke("setPoint1X", point1_x, float)

    point1X = pyqtProperty(float, fget=point1_x.fget, fset=point1_x.fset, notify=point1_x_changed)

    # y-coordinate
    # ============
    point1_y_changed = pyqtSignal(name="point1YChanged")

    @property
    def point1_y(self):
        return float(self.__point1_y)

    @point1_y.setter
    def point1_y(self, point1_y):
        if self.__point1_y != point1_y:
            self.__point1_y = point1_y
            self.point1_y_changed.emit()
            self.invoke("setPoint1Y", point1_y, float)

    point1Y = pyqtProperty(float, fget=point1_y.fget, fset=point1_y.fset, notify=point1_y_changed)

    # z-coordinate
    # ============
    point1_z_changed = pyqtSignal(name="point1ZChanged")

    @property
    def point1_z(self):
        return float(self.__point1_z)

    @point1_z.setter
    def point1_z(self, point1_z):
        if self.__point1_z != point1_z:
            self.__point1_z = point1_z
            self.point1_z_changed.emit()
            self.invoke("setPoint1Z", point1_z, float)

    point1Z = pyqtProperty(float, fget=point1_z.fget, fset=point1_z.fset, notify=point1_z_changed)

    '''
    Point2
    ======
    '''
    # x-coordinate
    # ============
    point2_x_changed = pyqtSignal(name="point2XChanged")

    @property
    def point2_x(self):
        return float(self.__point2_x)

    @point2_x.setter
    def point2_x(self, point2_x):
        if self.__point2_x != point2_x:
            self.__point2_x = point2_x
            self.point2_x_changed.emit()
            self.invoke("setPoint2X", point2_x, float)

    point2X = pyqtProperty(float, fget=point2_x.fget, fset=point2_x.fset, notify=point2_x_changed)

    # y-coordinate
    # ============
    point2_y_changed = pyqtSignal(name="point2YChanged")

    @property
    def point2_y(self):
        return float(self.__point2_y)

    @point2_y.setter
    def point2_y(self, point2_y):
        if self.__point2_y != point2_y:
            self.__point2_y = point2_y
            self.point2_y_changed.emit()
            self.invoke("setPoint2Y", point2_y, float)

    point2Y = pyqtProperty(float, fget=point2_y.fget, fset=point2_y.fset, notify=point2_y_changed)

    # z-coordinate
    # ============
    point2_z_changed = pyqtSignal(name="point2ZChanged")

    @property
    def point2_z(self):
        return float(self.__point2_z)

    @point2_z.setter
    def point2_z(self, point2_z):
        if self.__point2_z != point2_z:
            self.__point2_z = point2_z
            self.point2_z_changed.emit()
            self.invoke("setPoint2Z", point2_z, float)

    point2Z = pyqtProperty(float, fget=point2_z.fget, fset=point2_z.fset, notify=point2_z_changed)
