# External modules
# ================
from PyQt5.QtCore import QObject, qDebug, pyqtSignal, pyqtSlot, pyqtProperty, QVariant, QThread, Qt

# DICE modules
# ============
from core.dice.vis.basic_wrapper import BasicWrapper
from core.dice.vis.camera import Camera


class VisApp:
    """
    Mixin for BasicApp that handles the properties for the visualisation.
    """

    def __init__(self):
        self._vis_objects = []
        self._vis_objects_tree = []
        self._selected_vis_object = None
        self._selected_vis_object_path = []
        self._center_point = None
        self._bounding_box = None
        self._camera = Camera(self)

    vis_objects_changed = pyqtSignal(name="visObjectsChanged")

    @property
    def vis_objects(self):
        return self._vis_objects

    @vis_objects.setter
    def vis_objects(self, vis_objects):
        if self._vis_objects != vis_objects:
            self._vis_objects = vis_objects
            self.vis_objects_changed.emit()
            self.__update_vis_objects_tree()

    visObjects = pyqtProperty("QVariantList", fget=vis_objects.fget, fset=vis_objects.fset, notify=vis_objects_changed)

    def add_vis_object(self, vo):
        self.debug("vis objects "+str(self.vis_objects))
        vo.moveToThread(self.dice.thread())  # the vis objects must always be in the QML thread
        self._vis_objects.append(vo)
        self.vis_objects_changed.emit()
        self.__update_vis_objects_tree()
        self.camera.update()

    def remove_vis_object(self, vo):
        try:
            self._vis_objects.remove(vo)
            self.vis_objects_changed.emit()
            self.__update_vis_objects_tree()
            self.camera.update()
        except ValueError:
            qDebug("removing "+str(vo)+" which is not in vis_objects")

    vis_objects_tree_changed = pyqtSignal(name="visObjectsTreeChanged")

    @property
    def vis_objects_tree(self):
        return self._vis_objects_tree

    @vis_objects_tree.setter
    def vis_objects_tree(self, vis_objects_tree):
        if self._vis_objects_tree != vis_objects_tree:
            self._vis_objects_tree = vis_objects_tree
            self.vis_objects_tree_changed.emit()

    visObjectsTree = pyqtProperty("QVariantList", fget=vis_objects_tree.fget, fset=vis_objects_tree.fset,
                                  notify=vis_objects_tree_changed)

    def __update_vis_objects_tree(self):
        self._vis_objects_tree = []
        for vo in self._vis_objects:
            try:
                self._vis_objects_tree.extend(vo.tree_info)
                self._vis_objects_tree = sorted(self._vis_objects_tree, key=lambda element: element['text'])
            except AttributeError:
                qDebug("no tree_info in "+str(vo))
        self.vis_objects_tree_changed.emit()

    def vis_object_changed(self, vis_object):
        """
        This method if called from vis_objects with itself as the parameter to update the vis_objects_tree
        :param vis_object: the object that has been changed
        """
        self.__update_vis_objects_tree()

    selected_vis_object_path_changed = pyqtSignal(name="selectedVisObjectPathChanged")

    @property
    def selected_vis_object_path(self):
        return self._selected_vis_object_path

    @selected_vis_object_path.setter
    def selected_vis_object_path(self, selected_vis_object_path):
        if self._selected_vis_object_path != selected_vis_object_path:
            self.__set_selected_vis_object_by_path(selected_vis_object_path)
            self._selected_vis_object_path = selected_vis_object_path
            self.selected_vis_object_path_changed.emit()

    selectedVisObjectPath = pyqtProperty("QStringList", fget=selected_vis_object_path.fget,
                                         fset=selected_vis_object_path.fset, notify=selected_vis_object_path_changed)

    selected_vis_object_changed = pyqtSignal(name="selected_vis_objectChanged")

    @property
    def selected_vis_object(self):
        return self._selected_vis_object

    @selected_vis_object.setter
    def selected_vis_object(self, selected_vis_object):
        if self._selected_vis_object != selected_vis_object:
            self._selected_vis_object = selected_vis_object
            self.selected_vis_object_changed.emit()

    selectedVisObject = pyqtProperty(BasicWrapper, fget=selected_vis_object.fget,
                                     fset=selected_vis_object.fset, notify=selected_vis_object_changed)

    def __set_selected_vis_object_by_path(self, path):
        for vo in self._vis_objects:
            if vo.has_path(path):
                self.selected_vis_object = vo
                return
        else:
            qDebug("no vis object found for path: "+str(path))

    camera_changed = pyqtSignal(name="cameraChanged")
    
    @pyqtProperty(Camera, notify=camera_changed)
    def camera(self):
        return self._camera
    
    @camera.setter
    def camera(self, camera):
        if self._camera != camera:
            self._camera = camera
            self.camera_changed.emit()

    @pyqtSlot(QObject, name="connectCamera")
    def connect_camera(self, camera):
        self._camera.connect_with(camera)

    """
    Special geometries.
    ###################
    """
    center_point_changed = pyqtSignal(name="centerPointChanged")

    @property
    def center_point(self):
        return self._center_point

    @center_point.setter
    def center_point(self, center_point):
        if self._center_point != center_point:
            self._center_point = center_point
            self.center_point_changed.emit()

    centerPoint = pyqtProperty(QObject, fget=center_point.fget, fset=center_point.fset, notify=center_point_changed)

    bounding_box_changed = pyqtSignal(name="bounding_boxChanged")

    @property
    def bounding_box(self):
        return self._bounding_box

    @bounding_box.setter
    def bounding_box(self, bounding_box):
        if self._bounding_box != bounding_box:
            self._bounding_box = bounding_box
            self.bounding_box_changed.emit()

    boundingBox = pyqtProperty(QObject, fget=bounding_box.fget, fset=bounding_box.fset, notify=bounding_box_changed)