from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, QTimer, qDebug


class MemoryInfo(QObject):
    def __init__(self, parent=None):
        super(MemoryInfo, self).__init__(parent)

        self.__usage = 0
        self.load_usage()
        self.__timer = QTimer(self)
        self.__timer.setInterval(1000)
        self.__timer.setSingleShot(False)
        self.__timer.timeout.connect(self.load_usage)
        self.__timer.start()

    def load_usage(self):
        with open("/proc/self/status") as f:
            data = f.read()
        index = data.index("VmRSS:")
        split = data[index:].split(None, 3)
        self.__usage = int(split[1])
        self.usage_changed.emit()

    usage_changed = pyqtSignal(name="usageChanged")
    
    @pyqtProperty(int, notify=usage_changed)
    def usage(self):
        return self.__usage
    
    @usage.setter
    def usage(self, usage):
        if self.__usage != usage:
            self.__usage = usage
            self.usage_changed.emit()