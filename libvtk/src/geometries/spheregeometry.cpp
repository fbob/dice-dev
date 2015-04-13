#include "spheregeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

SphereGeometry::SphereGeometry(QObject* parent) : GeometryBase(parent)
{
}

void SphereGeometry::createActors()
{
    if (actor) return;

    sphere = vtkSmartPointer<vtkSphereSource>::New();
    sphere->SetCenter(0.0, 0.0, 0.0);
    sphere->SetRadius(1);
    sphere->SetThetaResolution(50);
    sphere->SetPhiResolution(50);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(sphere->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["sphere"] = actor.Get();
}

QStringList SphereGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"sphere"};
    else
        return {};
}

void SphereGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void SphereGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void SphereGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], pos[1], z);
    renderer->needUpdate();
}

void SphereGeometry::setRadius(double radius)
{
    if (isnan(radius)) return;
    sphere->SetRadius(radius);
    renderer->needUpdate();
}
