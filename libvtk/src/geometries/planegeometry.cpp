#include "planegeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

PlaneGeometry::PlaneGeometry(QObject *parent) : GeometryBase(parent)
{
}

void PlaneGeometry::createActors()
{
    if (actor) return;

    plane = vtkSmartPointer<vtkPlaneSource>::New();
    plane->SetOrigin(-0.5, -0.5, 0);
    plane->SetPoint1(0.5, -0.5, 0);
    plane->SetPoint2(-0.5, 0.5, 0);
    plane->SetXResolution(1);
    plane->SetYResolution(1);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(plane->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["plane"] = actor;
}

QStringList PlaneGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"plane"};
    else
        return {};
}

void PlaneGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetOrigin(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetOrigin(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetOrigin(pos[0], pos[1], z);
    renderer->needUpdate();
}

void PlaneGeometry::setOriginX(double x)
{
    if (isnan(x)) return;
    double* pt = plane ->GetOrigin();
    plane->SetPoint1(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setOriginY(double y)
{
    if (isnan(y)) return;
    double* pt = plane ->GetOrigin();
    plane->SetPoint1(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setOriginZ(double z)
{
    if (isnan(z)) return;
    double* pt = plane ->GetOrigin();
    plane->SetPoint1(pt[0], pt[1], z);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint1X(double x)
{
    if (isnan(x)) return;
    double* pt = plane ->GetPoint1();
    plane->SetPoint1(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint1Y(double y)
{
    if (isnan(y)) return;
    double* pt = plane ->GetPoint1();
    plane->SetPoint1(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint1Z(double z)
{
    if (isnan(z)) return;
    double* pt = plane ->GetPoint1();
    plane->SetPoint1(pt[0], pt[1], z);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint2X(double x)
{
    if (isnan(x)) return;
    double* pt = plane ->GetPoint2();
    plane->SetPoint1(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint2Y(double y)
{
    if (isnan(y)) return;
    double* pt = plane ->GetPoint2();
    plane->SetPoint1(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void PlaneGeometry::setPoint2Z(double z)
{
    if (isnan(z)) return;
    double* pt = plane ->GetPoint2();
    plane->SetPoint1(pt[0], pt[1], z);
    renderer->needUpdate();
}

