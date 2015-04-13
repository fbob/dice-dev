/*
 * This is based on qmlscene/pluginloader.h from PyQt (Copyright (c) 2014 Riverbank Computing Limited <info@riverbankcomputing.com>)
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


#ifndef _PYTHONLOADER_H
#define _PYTHONLOADER_H

#undef slots
#include <Python.h>
#define slots
#include <sip.h>

#include <QObject>
#include <QQmlExtensionPlugin>


class PythonLoader: QObject
{
    Q_OBJECT
public:
    PythonLoader(QObject *parent = 0);
    virtual ~PythonLoader();

    QObject* getObject(QString package, QString name);

private:
    void getSipAPI();
    static bool addToSysPath(const QString &py_plugin_dir);
    static PyObject *getModuleAttr(const char *module, const char *attr);

    const sipAPIDef *sip = nullptr;
    PyObject* py_object = nullptr;
};


#endif
