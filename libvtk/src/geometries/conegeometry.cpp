#include "conegeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

ConeGeometry::ConeGeometry(QObject *parent) : GeometryBase(parent)
{
}

void ConeGeometry::createActors()
{
    if (actor) return;

    cone = vtkSmartPointer<vtkConeSource>::New();
    cone->SetCenter(0, 0, 0);
    cone->SetRadius(1);
    cone->SetHeight(10);
    cone->SetDirection(1, 0, 0);
    cone->SetResolution(100);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cone->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["cone"] = actor;
}

QStringList ConeGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"cone"};
    else
        return {};
}

void ConeGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void ConeGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void ConeGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], pos[1], z);
    renderer->needUpdate();
}

void ConeGeometry::setRadius(double radius)
{
    cone->SetRadius(radius);
    renderer->needUpdate();
}

void ConeGeometry::setHeight(double height)
{
    cone->SetHeight(height);
    renderer->needUpdate();
}

void ConeGeometry::setDirectionX(double directionX)
{
    if (isnan(directionX)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    cone->SetDirection(directionX, pos[1], pos[2]);
    renderer->needUpdate();
}

void ConeGeometry::setDirectionY(double directionY)
{
    if (isnan(directionY)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    cone->SetDirection(pos[0], directionY, pos[2]);
    renderer->needUpdate();
}

void ConeGeometry::setDirectionZ(double directionZ)
{
    if (isnan(directionZ)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    cone->SetDirection(pos[0], pos[1], directionZ);
    renderer->needUpdate();
}
