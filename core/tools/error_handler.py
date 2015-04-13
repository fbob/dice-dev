from PyQt5.QtCore import QObject, pyqtProperty, pyqtSlot, pyqtSignal


class ErrorHandler(QObject):
    def __init__(self, parent=None):
        super(ErrorHandler, self).__init__(parent)
        self.__type = ""
        self.__msg = ""

    occurred = pyqtSignal()

    type_changed = pyqtSignal(name="typeChanged")

    @pyqtProperty(str, notify=type_changed)
    def type(self):
        return self.__type

    @type.setter
    def type(self, type):
        if self.__type != type:
            self.__type = type
            self.type_changed.emit()

    msg_changed = pyqtSignal(name="msgChanged")

    @pyqtProperty(str, notify=msg_changed)
    def msg(self):
        return self.__msg

    @msg.setter
    def msg(self, msg):
        if self.__msg != msg:
            self.__msg = msg
            self.msg_changed.emit()

