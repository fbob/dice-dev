# External modules
# ================
from PyQt5.QtCore import QUrl, pyqtSlot

# DICE modules
# ============
from core.app import BasicApp


class FoamApp(BasicApp):
    app_name = "NoNameFoamApp"

    def __init__(self, parent, instance_name, status):
        BasicApp.__init__(self, parent, instance_name, status)

        self.foam_files = dict()

    def register_foam_file(self, path, var):
        self.foam_files[path] = var
        self.signal(path)

    def get_foam_var(self, path=None):
        if path is None:
            return None
        file_name, var_path = self.split_path(path)
        var = self.foam_files[file_name]
        try:
            return self.get_value_by_path(var, var_path).val
        except AttributeError:
            return self.get_value_by_path(var, var_path)

    def set_foam_var(self, path, value):
        file_name, var_path = self.split_path(path)
        if file_name in self.foam_files:
            var = self.foam_files[file_name]
            self.debug(value)
            py_foam_var = self.get_dict_by_path(var, var_path)
            try:
                py_foam_var[var_path[-1]] = value
            except TypeError:
                try:
                    if value == "$invalid$":
                        return
                    else:
                        py_foam_var[int(var_path[-1])] = value
                except ValueError:
                    raise KeyError("Could not set "+str(path)+" to "+str(value)+" (in "+str(py_foam_var)+")")

            var.writeFile()
            self.signal(file_name, var_path, value)

    def foam_var_signal_name(self, path=None):
        if path is not None:
            file_name, _ = self.split_path(path)
            # self.debug("fv "+file_name)  # TODO: check why we get paths like 0
            return file_name
        else:
            return None

    def create_foam_var(self, path, value):
        file_name, var_path = self.split_path(path)
        if file_name in self.foam_files:
            var = self.foam_files[file_name]
            if not self.foam_dict_exists(var_path):
                self.create_dict_in_path(path)
            py_foam_var = self.get_dict_by_path(var, var_path)
            py_foam_var[var_path[-1]] = value
            var.writeFile()

    def foam_var_exists(self, path):
        if path is None:
            return False
        file_name, var_path = self.split_path(path)
        if file_name in self.foam_files:
            var = self.foam_files[file_name]
            try:
                self.get_value_by_path(var, var_path)
                return True
            except KeyError:
                return False
        else:
            return False

    def set_invalid_or_remove_var(self, path, set_invalid):
        if set_invalid:
            self.set_foam_var(path, "$invalid$")
        else:
            self.remove_from_dict(path)

    def get_var_and_path(self, path):
        file_name, var_path = self.split_path(path)
        return self.foam_files[file_name], var_path

    def remove_from_dict(self, path):
        foam_file, var_path = self.get_var_and_path(path)
        var = self.get_dict_by_path(foam_file, var_path)
        del var[var_path[-1]]
        foam_file.writeFile()

    def create_dict_in_path(self, path, default_value={}):
        file_name, var_path = self.split_path(path)
        if file_name in self.foam_files:
            var = self.foam_files[file_name]
            self.__create_dict(var, var_path, default_value)
            var.writeFile()

    def __create_dict(self, var, var_path, default_value):
        head, *tails = var_path
        if not tails:
            if head not in var:
                var[head] = default_value
            return
        try:
            self.__create_dict(var[head], tails, default_value)
        except KeyError:
            var[head] = {}
            self.__create_dict(var[head], tails, default_value)

    def foam_dict_exists(self, path):
        file_name, var_path = self.split_path(path)
        if file_name in self.foam_files:
            var = self.foam_files[file_name]
            try:
                self.get_dict_by_path(var, var_path)[var_path[-1]]
                return True
            except KeyError:
                return False
        else:
            return False

    def set_foam_var_yes_no(self, path, *args):
        """
        Special variant of set_foam_var that converts "yes"/"no" to True/False
        :param path:
        :param args:
        :return:
        """
        def convert(x):
            if type(x) == bool:
                return "yes" if x else "no"
            else:
                return x
        self.set_foam_var(path, *tuple(map(convert, args)))  # convert each element in args

    def get_foam_var_yes_no(self, path=None, *args):
        """
        Special variant of get_foam_var that converts True/False to "yes"/"no"
        :param path:
        :param args:
        :return:
        """
        def convert(x):
            try:
                return True if x.lower() == "yes" else False if x.lower() == "no" else x
            except AttributeError:
                return x
        return convert(self.get_foam_var(path, *args))

    def foam_var_yes_no_signal_name(self):
        return ""

    # def create_log(self, line):
    #     self.debug("stdout "+line)
    #     with open(self.current_run_path("log"), "a") as log_file:
    #         log_file.write(line)

    def foam_exec(self, args, stdout=None, stderr=None, cwd=None):
        f_args = [self.dice.settings.value(self, 'foamExec')]
        f_args.extend(args)
        result = self.run_process(f_args, stdout=stdout, stderr=stderr, cwd=cwd)
        return result





