import unittest
from tempfile import gettempdir
import shutil
import os

from core.app import BasicApp
from core.main import Dice
from core_apps.Desk.core_app import Desk
from core_apps.Home.core_app import Home
from core.dice.tools.json_sync import JsonOrderedDict


class TestApp(unittest.TestCase):

    temp_dir = ""
    dice = None
    app = None

    def setUp(self):
        self.dice = Dice()
        desk = Desk(parent=self.dice)
        self.dice.desk = desk

        home = Home(parent=self.dice)
        self.dice.home = home

        self.temp_dir = gettempdir()
        try:
            shutil.rmtree(os.path.join(self.temp_dir, "test_project"))
        except FileNotFoundError:
            pass

        self.dice.create_new_project("test_project", self.temp_dir, "description")  # TODO: create TestDice unit test

        self.app = BasicApp(parent=None, instance_name="test_app", status=BasicApp.IDLE)
        self.app.setParent(self.dice.desk)

    def tearDown(self):
        shutil.rmtree(os.path.join(self.temp_dir, "test_project"))

    def test_config_file_written_when_status_changed(self):
        self.app.status = BasicApp.FINISHED
        app_dice = JsonOrderedDict(self.app.config_path("app.dice"))
        self.assertEqual(BasicApp.FINISHED, app_dice["General"]["status"])

    def test_prepare_returns_true_by_default(self):
        self.assertTrue(self.app.prepare())

    def test_run_returns_false_by_default(self):
        self.assertFalse(self.app.run())

if __name__ == '__main__':
    unittest.main()
