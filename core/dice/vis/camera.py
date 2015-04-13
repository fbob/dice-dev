# External modules
# ================
from PyQt5.QtCore import QObject, pyqtSlot, qDebug, Q_ARG, pyqtProperty, pyqtSignal
from PyQt5.Qt import Qt


class Camera(QObject):
    def __init__(self, parent=None):
        super(Camera, self).__init__(parent)

        self._object = None
        self._methods = {}

        self._parallel_projection = False

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

    def invoke(self, method_name, value=None, value_type=None, connection=Qt.QueuedConnection):
        if value_type is None:
            arg = Q_ARG(type(value), value)
        else:
            arg = Q_ARG(value_type, value)

        try:
            self._methods[method_name].invoke(self._object, connection, arg)
        except KeyError:
            qDebug("no method "+str(method_name)+" found in "+str(self._object))
            qDebug("methods: "+str(self._methods))

    def invoke_xyz(self, method_name, x, y, z, x_type=None, y_type=None, z_type=None, connection=Qt.QueuedConnection):
        if x_type is None:
            arg_x = Q_ARG(type(x), x)
        else:
            arg_x = Q_ARG(x_type, x)
        if x_type is None:
            arg_y = Q_ARG(type(y), y)
        else:
            arg_y = Q_ARG(y_type, y)
        if x_type is None:
            arg_z = Q_ARG(type(z), z)
        else:
            arg_z = Q_ARG(z_type, z)

        try:
            self._methods[method_name].invoke(self._object, connection, arg_x, arg_y, arg_z)
        except KeyError:
            qDebug("no method "+str(method_name)+" found in "+str(self._object))
            qDebug("methods: "+str(self._methods))

    def invoke_direct(self, method_name, value_type_or_q_arg, value=None):
        self.invoke(method_name, value_type_or_q_arg, value, connection=Qt.DirectConnection)

    @pyqtSlot()
    def update(self):
        self.invoke("update")

    @pyqtSlot(name="resetCamera")
    def reset_camera(self):
        self.invoke("resetCamera")
        self.update()

    @pyqtSlot(float, float, float, name="setPosition")
    def set_position(self, x, y, z):
        self.invoke_xyz("setPosition", x, y, z, float, float, float)

    @pyqtSlot(int, int, int, name="setViewUp")
    def set_view_up(self, x, y, z):
        self.invoke_xyz("setViewUp", x, y, z)

    @pyqtSlot(float, float, float, name="setFocalPoint")
    def set_focal_point(self, x, y, z):
        self.invoke_xyz("setFocalPoint", x, y, z)

    @pyqtSlot(str)
    def align(self, alignment):
        if alignment == "+x":
            self.set_position(-20, 0, 0)
            self.set_view_up(0, 0, 1)
            self.set_focal_point(0, 0, 0)
        elif alignment == "-x":
            self.set_position(20, 0, 0)
            self.set_view_up(0, 0, 1)
            self.set_focal_point(0, 0, 0)
        elif alignment == "+y":
            self.set_position(0, -20, 0)
            self.set_view_up(0, 0, 1)
            self.set_focal_point(0, 0, 0)
        elif alignment == "-y":
            self.set_position(0, 20, 0)
            self.set_view_up(0, 0, 1)
            self.set_focal_point(0, 0, 0)
        elif alignment == "+z":
            self.set_position(0, 0, -20)
            self.set_view_up(0, 1, 0)
            self.set_focal_point(0, 0, 0)
        elif alignment == "-z":
            self.set_position(0, 0, 20)
            self.set_view_up(0, 1, 0)
            self.set_focal_point(0, 0, 0)

        self.reset_camera()

    parallel_projection_changed = pyqtSignal(name="parallel_projectionChanged")

    @property
    def parallel_projection(self):
        return self._parallel_projection

    @parallel_projection.setter
    def parallel_projection(self, parallel_projection):
        if self._parallel_projection != parallel_projection:
            self._parallel_projection = parallel_projection
            self.parallel_projection_changed.emit()
            self.invoke("setParallelProjection", parallel_projection)
            self.update()

    parallelProjection = pyqtProperty(bool, fget=parallel_projection.fget, fset=parallel_projection.fset,
                                      notify=parallel_projection_changed)