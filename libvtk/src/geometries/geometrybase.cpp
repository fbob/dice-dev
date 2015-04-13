#include "geometrybase.h"

#include "vtkqfborenderer.h"

GeometryBase::GeometryBase(QObject* parent) : QObject(parent)
{
    renderer = qobject_cast<vtkQFBORenderer*>(parent);
}

GeometryBase::~GeometryBase()
{

}

QMap<QString, vtkActor *> GeometryBase::actors()
{
    if (m_actors.size() == 0)
        createActors();
    return m_actors;
}

void GeometryBase::setVisible(bool visible)
{
    for (vtkActor* actor: actors())
        actor->SetVisibility(visible);
    renderer->needUpdate();
}

void GeometryBase::setRepresentation(QString representation)
{
    if (representation == "Surface") {
        for (vtkActor* actor: actors()) {
            actor->GetProperty()->SetRepresentationToSurface();
            actor->GetProperty()->EdgeVisibilityOff();
        }
    } else if (representation == "SurfaceWithEdges") {
        for (vtkActor* actor: actors()) {
            actor->GetProperty()->SetRepresentationToSurface();
            actor->GetProperty()->EdgeVisibilityOn();
        }

    } else if (representation == "Wireframe") {
        for (vtkActor* actor: actors()) {
            actor->GetProperty()->SetRepresentationToWireframe();
        }
    } else if (representation == "Points") {
        for (vtkActor* actor: actors()) {
            actor->GetProperty()->SetRepresentationToPoints();
        }
    } else {
        qDebug() << "unknown representation" << representation;
    }
    renderer->needUpdate();
}
