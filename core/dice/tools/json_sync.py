from collections import OrderedDict
import json

from sys import stderr


def debug(msg):
    stderr.write(msg+"\n")
    stderr.flush()


class JsonOrderedDict(OrderedDict):
    """
    An OrderedDict replacement which loads and writes the date from and to a json file.
    """

    def __init__(self, file_name, autowrite=True, write_signal=None):
        super().__init__()
        self.file_name = file_name
        self.autowrite = autowrite
        self.write_signal = write_signal
        self.__loading = False
        self.__load_file()

    def __load_file(self):
        self.__loading = True
        self.clear()
        try:
            with open(self.file_name) as f:
                self.update(json.load(f, object_pairs_hook=OrderedDict))
        except:
            pass
        finally:
            self.__loading = False

    def write(self):
        with open(self.file_name, "w") as f:
            json.dump(self, f, sort_keys=True, indent=4, separators=(',', ': '))
            if self.write_signal is not None:
                self.write_signal()

    def __try__write(self):
        if self.autowrite and not self.__loading:
            self.write()

    def __setitem__(self, key, value):
        super().__setitem__(key, value)
        self.__try__write()

    def __delitem__(self, key):
        super().__delitem__(key)
        self.__try__write()

    def clear(self):
        super().clear()
        self.__try__write()

    def pop(self, key, default=None):
        ret = super().pop(key, default=default)
        self.__try__write()
        return ret

    def popitem(self, last=True):
        ret = super().popitem(last=last)
        self.__try__write()
        return ret

    def update(self, E=None, **F):
        super().update(E, **F)
        self.__try__write()



class JsonList(list):
    """
    An list replacement which loads and writes the date from and to a json file.
    """

    def __init__(self, file_name, autowrite=True, write_signal=None):
        super().__init__()
        self.file_name = file_name
        self.autowrite = autowrite
        self.write_signal = write_signal
        self.__loading = False
        self.__load_file()

    def __load_file(self):
        self.__loading = True
        self.clear()
        try:
            with open(self.file_name) as f:
                self.extend(json.load(f, object_pairs_hook=OrderedDict))
        except:
            pass
        finally:
            self.__loading = False

    def write(self):
        with open(self.file_name, "w") as f:
            json.dump(self, f, sort_keys=True, indent=4, separators=(',', ': '))
            if self.write_signal is not None:
                self.write_signal()

    def __try__write(self):
        try:
            if self.autowrite and not self.__loading:
                self.write()
        except:
            debug("error writing "+self.file_name)

    def to_simple_list(self):
        """
        Converts the JsonList to a simple list by replacing OrderedDicts with simple dicts.
        """
        def convert_dict(the_dict):
            simple_dict = {}
            for key, value in the_dict.items():
                if isinstance(value, list):
                    simple_dict[key] = convert_list(value)
                elif isinstance(value, dict):
                    simple_dict[key] = convert_dict(value)
                else:
                    simple_dict[key] = value
            return simple_dict

        def convert_list(the_list):
            simple_list = []
            for item in the_list:
                if isinstance(item, dict):
                    simple_list.append(convert_dict(item))
                elif isinstance(item, list):
                    simple_list.append(convert_list(item))
                else:
                    simple_list.append(item)
            return simple_list

        return convert_list(self)

    def __setitem__(self, key, value):
        super().__setitem__(key, value)
        self.__try__write()

    def __delitem__(self, key):
        super().__delitem__(key)
        self.__try__write()

    def append(self, p_object):
        super().append(p_object)
        self.__try__write()

    def extend(self, iterable):
        super().extend(iterable)
        self.__try__write()

    def clear(self):
        super().clear()
        self.__try__write()

    def pop(self, *args):
        ret = super().pop(*args)
        self.__try__write()
        return ret

    def remove(self, value):
        super().remove(value)
        self.__try__write()

    def insert(self, index, p_object):
        super().insert(index, p_object)
        self.__try__write()

#
# if __name__ == "__main__":
#     jl = JsonList("test.json")
#     print(jl)
#     jl[0] = "test"