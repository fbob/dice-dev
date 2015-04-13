#include "vtk_plugin.h"
#include "src/fborenderitem.h"

#include <qqml.h>

void VtkPlugin::registerTypes(const char *uri)
{
    // @uri DICE.App.Renderer
    qmlRegisterType<FBORenderItem>(uri, 1, 0, "FBORenderer");
}
