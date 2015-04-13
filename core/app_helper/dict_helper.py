
class DictHelper:

    @staticmethod
    def split_path(path):
        if isinstance(path, str):
            path = path.split(" ")
        elif isinstance(path, int):
            path = str(path)

        filename, *rpath = path
        return (filename, rpath)

    @staticmethod
    def get_dict_by_path(dict_var, path):
        head, *tail = path
        if tail:
            try:
                return DictHelper.get_dict_by_path(dict_var[head], tail)
            except TypeError:
                try:
                    return DictHelper.get_dict_by_path(dict_var[int(head)], tail)
                except ValueError:
                    raise KeyError("Could not get "+str(path)+" in "+str(dict_var))
        else:
            return dict_var

    @staticmethod
    def get_value_by_path(var, path):
        head, *tail = path
        if tail:
            try:
                return DictHelper.get_value_by_path(var[head], tail)
            except TypeError:
                try:
                    return DictHelper.get_value_by_path(var[int(head)], tail)
                except ValueError:
                    raise KeyError("Could not get "+str(path)+" in "+str(var))
        else:
            try:
                return var[head]
            except TypeError:
                try:
                    return var[int(head)]
                except ValueError:
                    raise KeyError("Could not get "+str(path)+" in "+str(var))
