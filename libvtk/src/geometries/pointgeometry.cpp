#include "pointgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

PointGeometry::PointGeometry(QObject* parent) : GeometryBase(parent)
{
}

void PointGeometry::createActors()
{
    if (actor) return;

    sphere = vtkSmartPointer<vtkSphereSource>::New();
    sphere->SetCenter(0.0, 0.0, 0.0);
    sphere->SetRadius(0.1); // TODO: resize radius based on bounding box of all actors
    sphere->SetThetaResolution(10);
    sphere->SetPhiResolution(10);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(sphere->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(1, 0, 0);
    m_actors["point"] = actor.Get();
}

QStringList PointGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"point"};
    else
        return {};
}

void PointGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void PointGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void PointGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], pos[1], z);
    renderer->needUpdate();
}

void PointGeometry::setRadius(double radius)
{
    if (isnan(radius)) return;
    sphere->SetRadius(radius);
    renderer->needUpdate();
}
