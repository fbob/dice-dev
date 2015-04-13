/*
 * This is based on qmlscene/pluginloader.cpp from PyQt (Copyright (c) 2014 Riverbank Computing Limited <info@riverbankcomputing.com>)
 *
 * This file may be used under the terms of the GNU General Public License
 * version 3.0 as published by the Free Software Foundation and appearing in
 * the file LICENSE included in the packaging of this file.  Please review the
 * following information to ensure the GNU General Public License version 3.0
 * requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 *
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */


#include <stdlib.h>

#include <Python.h>

#include <QCoreApplication>
#include <QDir>
#include <QLibraryInfo>
#include <QVector>
#include <QQmlEngine>
#include <QDebug>

#include "pythonloader.h"

PythonLoader::PythonLoader(QObject *parent) : QObject(parent)
{

    if (!Py_IsInitialized())
    {
        Py_Initialize();
        addToSysPath(QCoreApplication::applicationDirPath());

        getSipAPI();

        PyEval_InitThreads();
        PyEval_SaveThread();
    }
}


PythonLoader::~PythonLoader()
{
    if (Py_IsInitialized())
    {
        PyGILState_STATE gil = PyGILState_Ensure();

        Py_XDECREF(py_object);

        PyGILState_Release(gil);
    }
}

QObject *PythonLoader::getObject(QString package, QString name)
{
    PyGILState_STATE gil = PyGILState_Ensure();

    PyObject* package_mod = PyImport_ImportModule(package.toLatin1().data());
    if (!package_mod) {
        PyGILState_Release(gil);
        return nullptr;
    }

    PyObject* class_object = PyObject_GetAttrString(package_mod, name.toLatin1().data());
    if (!class_object) {
        Py_DecRef(package_mod);
        PyGILState_Release(gil);
        return nullptr;
    }

    const sipTypeDef *td = sip->api_find_type("QObject");
    PyObject *qSelf = sip->api_convert_from_type(this, td, 0);
    PyObject* argTuple = PyTuple_New(1);
    PyTuple_SetItem(argTuple, 0, qSelf);

    py_object = PyObject_CallObject(class_object, argTuple);
    Q_ASSERT(py_object != nullptr);

    sipSimpleWrapper* wrapper = reinterpret_cast<sipSimpleWrapper*>(py_object);
    QObject* qObject = (QObject*)(wrapper->data);

    Py_DecRef(class_object);
    Py_DecRef(package_mod);
    PyGILState_Release(gil);
    return qObject;
}

bool PythonLoader::addToSysPath(const QString &py_plugin_dir)
{
    PyObject *sys_path = getModuleAttr("sys", "path");

    if (!sys_path)
        return false;

    PyObject *plugin_dir_obj = PyUnicode_FromKindAndData(PyUnicode_2BYTE_KIND,
                                                         py_plugin_dir.constData(), py_plugin_dir.length());

    if (!plugin_dir_obj)
    {
        Py_DECREF(sys_path);
        return false;
    }


    int rc = PyList_Append(sys_path, plugin_dir_obj);
    Py_DECREF(plugin_dir_obj);
    Py_DECREF(sys_path);

    if (rc < 0)
    {
        return false;
    }

    return true;
}


PyObject *PythonLoader::getModuleAttr(const char *module, const char *attr)
{
    PyObject *mod = PyImport_ImportModule(module);

    if (!mod)
        return 0;

    PyObject *obj = PyObject_GetAttrString(mod, attr);

    Py_DECREF(mod);

    return obj;
}


void PythonLoader::getSipAPI()
{
    sip = (const sipAPIDef *)PyCapsule_Import("sip._C_API", 0);

    if (!sip)
        PyErr_Print();
}
