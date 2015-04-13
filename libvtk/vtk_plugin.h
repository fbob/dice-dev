#ifndef VTK_PLUGIN_H
#define VTK_PLUGIN_H

#include <QQmlExtensionPlugin>

class VtkPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // VTK_PLUGIN_H

