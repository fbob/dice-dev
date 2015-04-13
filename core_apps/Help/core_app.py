import os
from PyQt5.QtCore import pyqtProperty, pyqtSlot, pyqtSignal, QUrl

from core.dice.core_app import CoreApp
from core.app import BasicApp
from core.app_helper.dict_helper import DictHelper


class Help(CoreApp, DictHelper):

    def __init__(self, parent=None):
        super(Help, self).__init__(parent)

        self.__home_html_path = os.path.abspath("core_apps/Help/view/HTML/index.html")
        self.__docs_css = os.path.abspath("core_apps/Help/view/bootstrap-3.3.2-dist/css/bootstrap.css")
        self.__docs_font = os.path.abspath("core_apps/Help/view/bootstrap-3.3.2-dist/fonts/OpenSans/custom_font.css")

    docs_css_changed = pyqtSignal(name="docsCSSChanged")

    @property
    def docs_css(self):
        return self.__docs_css

    docsCSS = pyqtProperty(str, fget=docs_css.fget, notify=docs_css_changed)

    docs_font_changed = pyqtSignal(name="docsFontChanged")

    @property
    def docs_font(self):
        return self.__docs_font

    docsFont = pyqtProperty(str, fget=docs_font.fget, notify=docs_font_changed)

    # Home HTML Path
    # ==============
    home_html_path_changed = pyqtSignal(name="homeHTMLChanged")

    @property
    def home_html_path(self):
        return self.__home_html_path

    homeHTMLPath = pyqtProperty(str, fget=home_html_path.fget, notify=home_html_path_changed)

    # Get URL and fragment (e.g. "#maxCellSize")
    # ==========================================
    @pyqtSlot(BasicApp, str, name="getHelpUrl", result=QUrl)
    def get_help_url(self, app, help_path):
        """
        Parses a help path and returns the url for this path.
        :param str help_path: the path for the help, split by spaces
        :param BasicApp app: the app which is currently opened
        :return:
        """
        file_name, path = self.split_path(help_path)
        help_fragment = self.get_help_fragment(app, help_path)

        app_local_path = os.path.join(app.module_path(), "db", "help", file_name)+".html"
        app_local_url = QUrl.fromUserInput(app_local_path)
        if os.path.exists(app_local_path):
            app_local_url.setFragment(help_fragment)
            return app_local_url

        global_help_path = os.path.join(self.dice.application_dir, "db", "help", file_name)+".html"
        global_help_url = QUrl.fromUserInput(global_help_path)
        if os.path.exists(global_help_path):
            global_help_url.setFragment(help_fragment)
            return global_help_url

        return ""

    @pyqtSlot(BasicApp, str, name="getHelpFragment", result=str)
    def get_help_fragment(self, app, help_path):
        """
        Parses a help path and returns the url fragment for this path.
        :param str help_path: the path for the help, split by spaces
        :param BasicApp app: the app which is currently opened
        :return:
        """
        file_name, path = self.split_path(help_path)
        if len(path) > 0:
            return path[-1]
        return ""

