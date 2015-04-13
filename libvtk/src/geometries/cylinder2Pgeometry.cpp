#include "cylinder2Pgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

Cylinder2PGeometry::Cylinder2PGeometry(QObject *parent) : GeometryBase(parent)
{
}

void Cylinder2PGeometry::createActors()
{
    if (actor) return;

    line = vtkSmartPointer<vtkLineSource>::New();
    line->SetPoint1(0, 0, 0);
    line->SetPoint2(1, 1, 1);
    vtkSmartPointer<vtkPolyDataMapper> lineMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    lineMapper->SetInputConnection(line->GetOutputPort());

    // Create a tube (cylinder) around the line
    tubeFilter = vtkSmartPointer<vtkTubeFilter>::New();
    tubeFilter->SetInputConnection(line->GetOutputPort());
    tubeFilter->SetRadius(.025);
    tubeFilter->SetNumberOfSides(50);
    tubeFilter->Update();

    vtkSmartPointer<vtkPolyDataMapper> tubeMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    tubeMapper->SetInputConnection(tubeFilter->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(tubeMapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["cone2R"] = actor;
}

QStringList Cylinder2PGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"cylinder2P"};
    else
        return {};
}

void Cylinder2PGeometry::setRadius(double radius)
{
    tubeFilter->SetRadius(radius);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint1X(double x)
{
    qDebug() << "Point1X Changed: " << x;
    if (isnan(x)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint1Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint1Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], pt[1], z);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint2X(double x)
{
    if (isnan(x)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint2Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void Cylinder2PGeometry::setPoint2Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], pt[1], z);
    renderer->needUpdate();
}
