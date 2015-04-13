# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .line_wrapper import LineWrapper


class TubeWrapper(LineWrapper):
    def __init__(self, parent=None):
        super(TubeWrapper, self).__init__(parent)

        self.name = "Tube"

        self.__radius = 0.5

        self.__point1_x = 0.0
        self.__point1_y = 0.0
        self.__point1_z = 0.0

        self.__point2_x = 0.0
        self.__point2_y = 0.0
        self.__point2_z = 10.0

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

    radius = pyqtProperty(float, fget=radius.fget, fset=radius.fset, notify=radius_changed)