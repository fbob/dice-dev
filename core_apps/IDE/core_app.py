# Standard Python modules
# =======================
import os
import json
import tempfile

# External modules
# ================
from PyQt5.QtCore import pyqtProperty, pyqtSlot, pyqtSignal

# DICE modules
# ============
from core.dice.core_app import CoreApp
from core.app import BasicApp
from core.app_helper.dict_helper import DictHelper
from core.dice.tools.json_sync import JsonOrderedDict


class IDE(CoreApp, DictHelper):

    def __init__(self, parent=None):
        super(IDE, self).__init__(parent)

        settings_folder = os.path.join(os.path.expanduser("~"), ".config", "DICE", "IDE")
        if not os.path.exists(settings_folder):
            os.makedirs(settings_folder)

        self.__ide_conf = JsonOrderedDict(os.path.join(settings_folder, "ide.json"))
        self.__load_default_if_empty_ide_conf()

        self.__temp_dir_path = os.path.join(tempfile.gettempdir(), "DICE")
        if not os.path.exists(self.__temp_dir_path):
            os.makedirs(self.__temp_dir_path)
        self.__editor_html_path = os.path.join(self.__temp_dir_path, "index.html")
        self.__editor_temp_html_path = os.path.join(self.__temp_dir_path, "template.html")
        self.__editor_template_html_folder_path = os.path.abspath("core_apps/IDE/view/codemirror-5.0/")
        self.__editor_template_html_path = os.path.abspath("core_apps/IDE/view/codemirror-5.0/template.html")
        self.__current_edited_file_path = ""
        self.__editor_data = ""
        self.config = None

        if not os.path.exists(self.__editor_temp_html_path):
            self.copy(self.__editor_template_html_path, self.__temp_dir_path)
            self.__set_absolute_file_path_in_html_file()
        import shutil
        shutil.copy(self.__editor_temp_html_path, self.__editor_html_path)

    # Get and set config file properties
    # ==================================
    def _get_conf_property(self, name, default_value):
        if self.__ide_conf:
            if name in self.__ide_conf:
                return self.__ide_conf[name]
        return default_value

    def _set_conf_property(self, name, value):
        if self.__ide_conf:
            self.__ide_conf[name] = value

    # Editor HTML Path
    # ================
    editor_html_path_changed = pyqtSignal(name="homeHTMLChanged")

    @property
    def editor_html_path(self):
        return self.__editor_html_path

    editorHTMLPath = pyqtProperty(str, fget=editor_html_path.fget, notify=editor_html_path_changed)

    # Set absolute file path in html file
    # ===================================
    def __set_absolute_file_path_in_html_file(self):
        with open(self.__editor_temp_html_path, "r") as editor_template_file:
            editor_template_file_content = editor_template_file.read()
            self.editor_data = editor_template_file_content.replace('href="',
                                                                    'href="{0}/'.format(self.__editor_template_html_folder_path))
            self.editor_data = self.editor_data.replace('src="',
                                                        'src="{0}/'.format(self.__editor_template_html_folder_path))
            with open(self.__editor_temp_html_path, "w") as editor_html_file:
                editor_html_file.write(self.editor_data)

    # Editor data
    # ===========
    editor_data_changed = pyqtSignal(name="editorDataChanged")

    @property
    def editor_data(self):
        return self.__editor_data

    @editor_data.setter
    def editor_data(self, editor_data):
        if self.__editor_data != editor_data:
            self.__editor_data = editor_data
            self.editor_data_changed.emit()

    editorData = pyqtProperty(str, fget=editor_data.fget, fset=editor_data.fset, notify=editor_data_changed)

    # Current edited file path
    # ========================
    current_edited_file_path_changed = pyqtSignal(name="currentEditedFilePathChanged")

    @property
    def current_edited_file_path(self):
        return self.__current_edited_file_path

    @current_edited_file_path.setter
    def current_edited_file_path(self, current_edited_file_path):
        if self.__current_edited_file_path != current_edited_file_path:
            self.__current_edited_file_path = current_edited_file_path
            self.current_edited_file_path_changed.emit()

    currentEditedFilePath = pyqtProperty(str, fget=current_edited_file_path, notify=current_edited_file_path_changed)

    # Get data and setValue for the editor
    # ====================================
    @pyqtSlot(BasicApp, str, name="getDataByUrl")
    def get_data_by_url(self, app, help_path):
        file_name, path = self.split_path(help_path)
        file_name = file_name.replace("foam/", "") # based on help_path: "foam/+path", "foam/" needs to be removed

        app_local_path = os.path.join(app.config_path(), file_name)
        self.current_edited_file_path = app_local_path
        if os.path.exists(app_local_path):
            with open(app_local_path, "r") as file:
                file_content = file.read()
            with open(self.__editor_temp_html_path, "r") as editor_template_file:
                editor_template_file_content = editor_template_file.read()
                self.editor_data = editor_template_file_content.replace('<textarea id="code"></textarea>',
                                                                        '<textarea id="code">{0}</textarea>'.format(file_content))
            with open(self.__editor_html_path, "w") as editor_html_file:
                editor_html_file.write(self.editor_data)

    # Save data from editor
    # =====================
    @pyqtSlot(BasicApp, str, str, name="saveDataByUrl")
    def save_data_by_url(self, app, help_path, data):
        app_local_path = self.current_edited_file_path
        if os.path.exists(app_local_path):
            with open(app_local_path, "w") as file:
                file.write(data)

    # Select Theme
    # ============
    editor_theme_changed = pyqtSignal(name="editorThemeChanged")

    @property
    def editor_theme(self):
        return self._get_conf_property("editorTheme", "elegant")

    @editor_theme.setter
    def editor_theme(self, editor_theme):
        if self.editor_theme != editor_theme:
            self._set_conf_property("editorTheme", editor_theme)
            self.editor_theme_changed.emit()

    editorTheme = pyqtProperty(str, fget=editor_theme.fget, fset=editor_theme.fset, notify=editor_theme_changed)

    # Get editor theme index
    # ======================
    @pyqtSlot(name="getEditorThemeIndex", result=int)
    def get_editor_theme_index(self):
        return self.editor_themes_model.index(self.editor_theme)

    # Themes List
    # ===========
    editor_themes_model_changed = pyqtSignal(name="editorThemesModelChanged")

    @property
    def editor_themes_model(self):
        return ["default", "3024-day", "3024-night", "ambiance", "base16-dark", "base16-light",
                "blackboard", "cobalt", "colorforth", "eclipse", "elegant", "erlang-dark",
                "lesser-dark", "mbo", "mdn-like", "midnight", "monokai", "neat", "neo",
                "night", "paraiso-dark", "paraiso-light", "pastel-on-dark", "rubyblue",
                "solarized dark", "solarized light", "the-matrix", "tomorrow-night-bright",
                "tomorrow-night-eighties", "twilight", "vibrant-ink", "xq-dark", "xq-light",
                "zenburn"]

    editorThemesModel = pyqtProperty("QVariantList", fget=editor_themes_model.fget, notify=editor_themes_model_changed)

    def __load_default_if_empty_ide_conf(self):
        if self.__ide_conf == {}:
            self.__ide_conf["editorTheme"] = "default"