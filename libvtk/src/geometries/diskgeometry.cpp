#include "diskgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>
#include <vtkMath.h>

#include <sstream>

DiskGeometry::DiskGeometry(QObject* parent) : GeometryBase(parent)
{
}

void DiskGeometry::createActors()
{
    if (actor) return;

    disk = vtkSmartPointer<vtkDiskSource>::New();
    disk->SetOuterRadius(1);
    disk->SetInnerRadius(0);
    disk->SetCircumferentialResolution(50);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(disk->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["disk"] = actor.Get();

    this->setInitNormal();
}

QStringList DiskGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"disk"};
    else
        return {};
}

void DiskGeometry::setX(double x)
{
    if (isnan(x)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(x, pos[1], pos[2]);
    renderer->needUpdate();
}

void DiskGeometry::setY(double y)
{
    if (isnan(y)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], y, pos[2]);
    renderer->needUpdate();
}

void DiskGeometry::setZ(double z)
{
    if (isnan(z)) return;
    if (!actor) return;
    double* pos = actor->GetPosition();
    actor->SetPosition(pos[0], pos[1], z);
    renderer->needUpdate();
}

void DiskGeometry::setInitNormal()
{
    this->normal[0] = 0.0;
    this->normal[1] = 0.0;
    this->normal[2] = 1.0;

    this->updateNormal();
}

void DiskGeometry::updateNormal()
{
    if (!actor) return;

    double nx = this->normal[0];
    double ny = this->normal[1];
    double nz = this->normal[2];

    double r = sqrt(nx*nx + ny*ny + nz*nz);
    if (r == 0) return;
    double t = atan2(ny, nx);
    double p = acos(nz/r);

    double *orient = actor->GetOrientation();
    actor->SetOrientation(orient[0], vtkMath::DegreesFromRadians(p), vtkMath::DegreesFromRadians(t));

    renderer->needUpdate();
}

void DiskGeometry::setNormX(double nx)
{
    if (isnan(nx)) return;
    this->normal[0] = nx;
    this->updateNormal();
}

void DiskGeometry::setNormY(double ny)
{
    if (isnan(ny)) return;
    this->normal[1] = ny;
    this->updateNormal();
}

void DiskGeometry::setNormZ(double nz)
{
    if (isnan(nz)) return;
    this->normal[2] = nz;
    this->updateNormal();
}

void DiskGeometry::setRadius(double radius)
{
    disk->SetOuterRadius(radius);
    renderer->needUpdate();
}


