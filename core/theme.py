# DICE modules
# ============
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot


class Theme(QObject):

    def __init__(self, parent=None):
        super(Theme, self).__init__(parent)

        self.__color = Color(self)

    color_changed = pyqtSignal(name="colorChanged")

    @pyqtProperty(QObject, notify=color_changed)
    def color(self):
        return self.__color

    @color.setter
    def color(self, color):
        if self.__color != color:
            self.__color = color
            self.color_changed.emit()


class Color(QObject):

    def __init__(self, parent=None):
        super(Color, self).__init__(parent)

        self.__border = '#D9D9CE'

    border_changed = pyqtSignal(name="borderChanged")

    @pyqtProperty(str, notify=border_changed)
    def border(self):
        return self.__border

    @border.setter
    def border(self, border):
        if self.__border != border:
            self.__border = border
            self.border_changed.emit()

