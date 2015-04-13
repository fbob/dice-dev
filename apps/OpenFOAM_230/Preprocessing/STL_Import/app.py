# Standard Python modules
# =======================
import os
import copy

# External modules
# ================
from PyQt5.QtCore import pyqtSignal, pyqtProperty
from PyFoam.Basics.STLFile import STLFile
from PyFoam.Error import FatalErrorPyFoamException

# DICE modules
# ============
from core.dice.vis import STLLoader
from core.dice.tools import json_sync
from core.foamapp import FoamApp

# App modules
# ============
from .modules.surfaceCheck import SurfaceCheck
from .modules.surfaceOrient import SurfaceOrient
from .modules.surfaceTransformPoints import SurfaceTransformPoints
from .modules.surfaceAutoPatch import SurfaceAutoPatch
from .modules.surfaceMeshInfo import SurfaceMeshInfo
from .modules.surfaceCoarsen import SurfaceCoarsen
from .modules.surfaceRefineRedGreen import SurfaceRefineRedGreen
from .modules.surfaceSplitByPatch import SurfaceSplitByPatch


class STL_Import(FoamApp, SurfaceCheck, SurfaceOrient,
                     SurfaceTransformPoints, SurfaceAutoPatch,
                     SurfaceMeshInfo, SurfaceCoarsen, SurfaceRefineRedGreen,
                     SurfaceSplitByPatch):
    app_name = "STL Import"
    output_types = ["stl_files"]

    def __init__(self, parent, instance_name, status):
        FoamApp.__init__(self, parent, instance_name, status)
        SurfaceOrient.__init__(self)
        SurfaceTransformPoints.__init__(self)
        SurfaceAutoPatch.__init__(self)
        SurfaceMeshInfo.__init__(self)
        SurfaceCoarsen.__init__(self)

        self.__history = []
        self.__object_files = []

        self.__stl_files = []
        self.__stl_vis_objects = []

    def load(self):
        self.__history = json_sync.JsonList(self.config_path("history.json"))
        self.__object_files = json_sync.JsonList(self.config_path("files.json"))
        self.__stl_files = self.__load_stl_files()
        self.__load_stl_vis_objects()

        self.status = self.FINISHED

    def run(self):
        self.repeat_history()
        return True

    def __load_stl_files(self):
        files = []
        for f in self.__object_files:
            stl_file = STLFile(self.current_run_path(f['filePath']))
            try:
                stl_file.patchInfo()
                files.append(stl_file)
            except FatalErrorPyFoamException:
                pass
        return files

    def __load_stl_vis_objects(self):
        stl_vo_file_names = [stl_file.file_name for stl_file in self.__stl_vis_objects]
        for stl_file in self.__stl_files:
            if stl_file._filename not in stl_vo_file_names:
                stl_vo = STLLoader(stl_file)
                self.__stl_vis_objects.append(stl_vo)
                self.add_vis_object(stl_vo)

    history_changed = pyqtSignal(name="historyChanged")

    @pyqtProperty("QVariantList", notify=history_changed)
    def history(self):
        return self.__decorated_history()

    def __decorated_history(self):
        hist = self.__history.to_simple_list()
        for i in range(len(hist)):
            cmd = hist[i]['cmd'] if 'cmd' in hist[i] else ''
            method = getattr(self, "run_"+cmd) if cmd != '' else None
            hist[i]['doc'] = method.__doc__ if method is not None else cmd
            hist[i]['parameterStr'] = str(dict(hist[i]['parameters'])) if 'parameters' in hist[i] else ''
        return hist

    def add_cmd_to_history(self, cmd, parameters):
        """
        Adds a command and its parameters at the end of the history list.
        :param cmd:
        :param parameters:
        :return:
        """
        if self.config["recordHistory"]:
            self.__history.append({"cmd": cmd, "parameters": parameters})
            self.history_changed.emit()

    def remove_last_history_entry(self):
        """
        Removes the last command from the history and tries to undo it.
        If undoing fails, the command stays in the history.
        """
        entry = self.__history.pop()
        if not self.__try_undo_command(entry):
            self.__history.append(entry)
        else:
            self.history_changed.emit()  # changed signal only needed when undoing worked

    def __try_undo_command(self, command):
        """
        Tries to undo a command by calling the function with a prepended "undo_".
        If no such function exists, the whole history is repeated.
        :param str command: The command that should be undone.
        :return: bool: True when undoing worked, False otherwise
        """
        if 'cmd' in command:
            method = getattr(self, 'undo_'+command['cmd'], None)
            if method is not None:
                parameters = command['parameters'] if 'parameters' in command else {}
                method(**parameters)
            else:
                return self.repeat_history()
        else:
            self.alert("cannot undo "+str(command))
            return False
        return True

    def clear_history(self):
        del self.__history[:]
        self.history_changed.emit()

    def repeat_history(self):
        self.__object_files.clear()  # clear file model before rerunning, or the files will show up multiple times
        for item in self.__history:
            if 'cmd' in item:
                cmd = "run_"+item['cmd']
                try:
                    method = getattr(self, cmd)
                    parameters = item['parameters'] if 'parameters' in item else {}
                    method(**parameters)
                except AttributeError:
                    self.alert("cannot execute command: "+cmd)
                    return False
        return True

    def update_changed_stl_file(self, filename):
        for stl in list(self.__stl_files):
            if stl.filename() == filename:
                self.__stl_files.remove(stl)
        self.__stl_files.append(STLFile(self.current_run_path("files", filename)))
        self.object_files_changed.emit()
        self.stl_files_out_changed.emit()

        for vis in list(self.__stl_vis_objects):
            if vis.basename == filename:
                self.__stl_vis_objects.remove(vis)
                self.remove_vis_object(vis)
        self.__load_stl_vis_objects()

    object_files_changed = pyqtSignal(name="objectFilesChanged")

    @property
    def object_files(self):
        return [{'text': stl_file.filename(),
                 'filePath': "files/{0}".format(stl_file.filename()),
                 'elements':
                     [{'text': region['name'], 'filePath': "files/{0}".format(stl_file.filename())}
                      for region in stl_file.patchInfo()]}
                for stl_file in self.__stl_files
        ]

    objectFiles = pyqtProperty("QVariantList", fget=object_files.fget, notify=object_files_changed)

    def add_to_file_model(self, full_path, src, file_path):
        """
        Adds a stl file to the file model.
        :param full_path: The full path to the stl file
        :param src: The path of the original file
        :param file_path: relative file path, must start with "files/"
        """
        stl_file = STLFile(full_path)
        self.__stl_files.append(stl_file)

        vo = STLLoader(stl_file)
        self.__stl_vis_objects.append(vo)
        self.add_vis_object(vo)

        self.__object_files.append({'src': src, 'filePath': file_path})
        self.object_files_changed.emit()
        self.stl_files_out_changed.emit()

    def __remove_stl_by_file_path(self, file_path):
        stl_file_name = self.current_run_path(file_path)
        stl_file_to_remove = next((stl_file for stl_file in self.__stl_files
                                   if stl_file._filename == stl_file_name), None)
        stl_vo_to_remove = next((stl_vo for stl_vo in self.__stl_vis_objects
                                 if stl_vo.file_name == stl_file_name), None)
        if stl_file_to_remove is not None:
            self.__stl_files.remove(stl_file_to_remove)
        if stl_vo_to_remove is not None:
            self.remove_vis_object(stl_vo_to_remove)
            self.__stl_vis_objects.remove(stl_vo_to_remove)
        self.stl_files_out_changed.emit()

    def remove_from_file_model(self, file_path):
        """
        Removes  a file from the file model. file_path should start with "files/".
        :param file_path:
        """
        for f in self.__object_files:
            if f['filePath'] == file_path:
                self.__object_files.remove(f)
                self.object_files_changed.emit()
                self.__remove_stl_by_file_path(file_path)
                return

    def remove_file_by_path(self, path):
        filename = path[0]
        file_path = os.path.join("files", filename)
        src = next((f['src'] for f in self.__object_files if f['filePath'] == file_path), '')
        self.delete_object_file(filename, src, file_path)

    def import_files(self, urls):
        for url in urls:
            url = self.parse_url(url)
            file_path = self.config_path("files")
            file_name = os.path.basename(url)

            if self.check_if_already_imported(file_path, file_name):
                self.add_cmd_to_history('copy_object_file', {'path': url})
                self.run_copy_object_file(url)
            else:
                self.alert("Could not import "+str(url))

    def run_copy_object_file(self, path):
        """
        Copies an object file (stl) into the app and run folder.
        :param path: file path to copy from
        :return:
        """
        self.copy(path, self.config_path("files"))
        self.copy(path, self.current_run_path("files"))
        filename = os.path.basename(path)
        self.add_to_file_model(self.current_run_path("files", filename), src=path,
                               file_path=os.path.join("files", filename))

    def check_if_already_imported(self, path, file_name):
        file_path = os.path.join(path, file_name)
        return not os.path.exists(file_path)

    def undo_copy_object_file(self, path):
        filename = os.path.basename(path)
        self.rm(self.config_path("files", filename))
        self.rm(self.current_run_path("files", filename))
        self.remove_from_file_model(os.path.join("files", filename))

    def delete_object_file(self, filename, src, path):
        self.add_cmd_to_history("delete_object_file", {'filename': filename, 'src': src, 'path': path})
        self.run_delete_object_file(filename, src, path)

    def run_delete_object_file(self, filename, src, path):
        """
        Deletes a file from the app and run folder.
        :param filename: file to delete
        :return:
        """
        self.undo_copy_object_file(src)

    def undo_delete_object_file(self, filename, src, path):
        self.run_copy_object_file(src)

    def open_paraview(self):
        paraview = self.dice.settings.value(self, 'paraview')
        current_foam_path = self.current_run_path("view.foam")
        self.run_process([paraview, current_foam_path])

    def stl_files_out(self):
        return copy.deepcopy(self.__stl_files)

    stl_files_out_changed = pyqtSignal()
