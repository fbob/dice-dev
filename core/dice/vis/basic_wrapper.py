from PyQt5.QtCore import QObject, pyqtSlot, qDebug, Q_ARG, pyqtProperty, pyqtSignal
from PyQt5.Qt import Qt


class BasicWrapper(QObject):
    def __init__(self, parent=None):
        super(BasicWrapper, self).__init__(parent)

        self._object = None
        self._methods = {}

        self._representation = "Surface"
        self._visible = True
        self.__name = ""

        self.__tree_info = [{
            "text": self.name,
            "elements": []}
        ]

    @pyqtSlot(QObject, name="connectWith")
    def connect_with(self, q_object):
        """
        :param QObject q_object: the QObject to connect with
        """
        qDebug("connect with "+str(q_object.metaObject().className()))
        self._object = q_object
        meta_object = q_object.metaObject()

        for i in range(meta_object.methodCount()):
            method = meta_object.method(i)

            # we must convert the name to str, since it is a QByteArray at first
            method_name = bytes(method.name()).decode("utf-8")
            self._methods[method_name] = method
            self.__set_default_value(method_name)

    def __set_default_value(self, method_name):
        """
        Sets the default property value for each method that starts with "set".
        :param str method_name: the method name to use as setter
        :return:
        """
        if not method_name.startswith("set") or method_name in ("setVisible", "setRepresentation"):
            # special treatment for setVisible/setRepresentation as this will cause the actors to be created prematurely
            return

        property_name = method_name[3].lower() + method_name[4:]  # convert e.g. setMinX to minX
        if hasattr(self, property_name):
            value = getattr(self, property_name)  # get the property value from the wrapper
            self.invoke_direct(method_name, value)
        else:
            qDebug("no prop "+property_name)

    def invoke(self, method_name, value, value_type=None, connection=Qt.QueuedConnection):
        if value_type is None:
            arg = Q_ARG(type(value), value)
        else:
            arg = Q_ARG(value_type, value)

        try:
            self._methods[method_name].invoke(self._object, connection, arg)
        except KeyError:
            qDebug("no method "+str(method_name)+" found in "+str(self._object))
            qDebug("methods: "+str(self._methods))

    def invoke_direct(self, method_name, value_type_or_q_arg, value=None):
        self.invoke(method_name, value_type_or_q_arg, value, connection=Qt.DirectConnection)

    def has_path(self, path):
        """
        Override in each wrapper to determine if a path (list of strings for each element in the tree)
        is part of this object.
        :param list path: Path to the object
        :return: bool
        """
        if len(path) == 1:
            return path[0] == self.name
        return False

    representation_changed = pyqtSignal(name="representationChanged")

    @pyqtProperty(str, notify=representation_changed)
    def representation(self):
        return self._representation

    @representation.setter
    def representation(self, representation):
        if self._representation != representation:
            self._representation = representation
            self.representation_changed.emit()
            self.invoke("setRepresentation", representation)

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

    name_changed = pyqtSignal(name="nameChanged")

    @property
    def name(self):
        return self.__name

    @name.setter
    def name(self, name):
        if self.__name != name:
            self.__name = name
            self.tree_info_changed.emit()
            self.name_changed.emit()
            self.tree_info = [{
                "text": self.name,
                "object": self
            }]

    name = pyqtProperty(str, fget=name.fget, fset=name.fset, notify=name_changed)

    tree_info_changed = pyqtSignal(name="treeInfoChanged")

    @property
    def tree_info(self):
        return self.__tree_info

    @tree_info.setter
    def tree_info(self, tree_info):
        if self.__tree_info != tree_info:
            self.__tree_info = tree_info
            self.tree_info_changed.emit()

    treeInfo = pyqtProperty(str, fget=tree_info.fget, fset=tree_info.fset, notify=tree_info_changed)

