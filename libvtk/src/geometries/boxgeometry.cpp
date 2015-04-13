#include "boxgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

BoxGeometry::BoxGeometry(QObject *parent) : GeometryBase(parent)
{
}

void BoxGeometry::createActors()
{
    if (actor) return;

    cube = vtkSmartPointer<vtkCubeSource>::New();
    cube->SetCenter(0, 0, 0);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cube->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["box"] = actor;
}

QStringList BoxGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"box"};
    else
        return {};
}

void BoxGeometry::setMinX(double d)
{
    if (isnan(d)) return;
    if (!cube) return;
    double diff = maxX - d;
    double* c = cube->GetCenter();
    c[0] = (d+maxX)/2;
    cube->SetCenter(c);
    cube->SetXLength(diff);
    minX = d;
    renderer->needUpdate();
}

void BoxGeometry::setMaxX(double d)
{
    if (isnan(d)) return;
    double diff = d - minX;
    double* c = cube->GetCenter();
    c[0] = (minX+d)/2;
    cube->SetCenter(c);
    cube->SetXLength(diff);
    maxX = d;
    renderer->needUpdate();
}

void BoxGeometry::setMinY(double d)
{
    if (isnan(d)) return;
    double diff = maxY - d;
    double* c = cube->GetCenter();
    c[1] = (d+maxY)/2;
    cube->SetCenter(c[0], c[1], c[2]);
    cube->SetYLength(diff);
    minY = d;
    renderer->needUpdate();
}

void BoxGeometry::setMaxY(double d)
{
    if (isnan(d)) return;
    double diff = d - minY;
    double* c = cube->GetCenter();
    c[1] = (minY+d)/2;
    cube->SetCenter(c);
    cube->SetYLength(diff);
    maxY = d;
    renderer->needUpdate();
}

void BoxGeometry::setMinZ(double d)
{
    if (isnan(d)) return;
    double diff = maxZ - d;
    double* c = cube->GetCenter();
    c[2] = (d+maxZ)/2;
    cube->SetCenter(c);
    cube->SetZLength(diff);
    minZ = d;
    renderer->needUpdate();
}

void BoxGeometry::setMaxZ(double d)
{
    if (isnan(d)) return;
    double diff = d - minZ;
    double* c = cube->GetCenter();
    c[2] = (minZ+d)/2;
    cube->SetCenter(c);
    cube->SetZLength(diff);
    maxZ = d;
    renderer->needUpdate();
}

void BoxGeometry::setCenterX(double x)
{
    if (isnan(x)) return;
    double* c = cube->GetCenter();
    cube->SetCenter(x, c[1], c[2]);
    renderer->needUpdate();
}

void BoxGeometry::setCenterY(double y)
{
    if (isnan(y)) return;
    double* c = cube->GetCenter();
    cube->SetCenter(c[0], y, c[2]);
    renderer->needUpdate();
}

void BoxGeometry::setCenterZ(double z)
{
    if (isnan(z)) return;
    double* c = cube->GetCenter();
    cube->SetCenter(c[0], c[1], z);
    renderer->needUpdate();
}

void BoxGeometry::setXLength(double xlength)
{
    if (isnan(xlength)) return;
    cube->SetXLength(xlength);
    renderer->needUpdate();
}

void BoxGeometry::setYLength(double ylength)
{
    if (isnan(ylength)) return;
    cube->SetYLength(ylength);
    renderer->needUpdate();
}

void BoxGeometry::setZLength(double zlength)
{
    if (isnan(zlength)) return;
    cube->SetZLength(zlength);
    renderer->needUpdate();
}
