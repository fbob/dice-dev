# External modules
# ================
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal, qDebug, QMetaObject, QMetaMethod, Q_ARG

# DICE modules
# ============
from .line_wrapper import LineWrapper


class Cone2RWrapper(LineWrapper):
    def __init__(self, parent=None):
        super(Cone2RWrapper, self).__init__(parent)

        self.name = "Cone"

        self.__radius1 = 0.2
        self.__radius2 = 0.1

        self.__point1_x = 0.0
        self.__point1_y = 0.0
        self.__point1_z = 0.0

        self.__point2_x = 0.0
        self.__point2_y = 0.0
        self.__point2_z = 1.0

    '''
    Radius1
    =======
    '''
    radius1_changed = pyqtSignal(name="radius1Changed")

    @property
    def radius1(self):
        return float(self.__radius1)

    @radius1.setter
    def radius1(self, radius1):
        if self.__radius1 != radius1:
            self.__radius1 = radius1
            self.radius1_changed.emit()
            self.invoke("setRadius1", radius1, float)

    radius1 = pyqtProperty(float, fget=radius1.fget, fset=radius1.fset, notify=radius1_changed)

    '''
    Radius2
    =======
    '''
    radius2_changed = pyqtSignal(name="radius2Changed")

    @property
    def radius2(self):
        return float(self.__radius2)

    @radius2.setter
    def radius2(self, radius2):
        if self.__radius2 != radius2:
            self.__radius2 = radius2
            self.radius2_changed.emit()
            self.invoke("setRadius2", radius2, float)

    radius2 = pyqtProperty(float, fget=radius2.fget, fset=radius2.fset, notify=radius2_changed)