#include "cylindergeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

CylinderGeometry::CylinderGeometry(QObject *parent) : GeometryBase(parent)
{
}

void CylinderGeometry::createActors()
{
    if (actor) return;

    cylinder = vtkSmartPointer<vtkCylinderSource>::New();
    cylinder->SetCenter(0, 0, 0);
    cylinder->SetRadius(1);
    cylinder->SetHeight(10);
    cylinder->SetResolution(100);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cylinder->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["cylinder"] = actor;
}

QStringList CylinderGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"cylinder"};
    else
        return {};
}

void CylinderGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void CylinderGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void CylinderGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], pos[1], z);
    renderer->needUpdate();
}

void CylinderGeometry::setRadius(double radius)
{
    cylinder->SetRadius(radius);
    renderer->needUpdate();
}

void CylinderGeometry::setHeight(double height)
{
    cylinder->SetHeight(height);
    renderer->needUpdate();
}
