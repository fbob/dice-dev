from PyQt5.QtQml import QJSValue
from PyQt5.QtCore import qDebug


def convert_object_to_qjsvalue(obj, jsengine):
    """
    Convert any python object into a QJSValue. The conversion must happen in the GUI thread.
    :param obj:
    :param jsengine:
    :return:
    """
    if obj is None:
        return QJSValue()
    elif isinstance(obj, list) or isinstance(obj, tuple):
        length = len(obj)
        array = jsengine.newArray(length)
        for i, v in enumerate(obj):
            array.setProperty(i, convert_object_to_qjsvalue(v, jsengine))
        return array
    elif isinstance(obj, dict):
        array = jsengine.newArray()
        for k, v in obj.items():
            array.setProperty(k, convert_object_to_qjsvalue(v, jsengine))
        return array
    else:
        try:
            return QJSValue(obj)
        except TypeError:
            qDebug("unknown type: "+str(obj))
            return QJSValue()