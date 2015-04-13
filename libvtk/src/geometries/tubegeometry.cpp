#include "tubegeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

TubeGeometry::TubeGeometry(QObject *parent) : GeometryBase(parent)
{
}

void TubeGeometry::createActors()
{
    if (actor) return;

    line = vtkSmartPointer<vtkLineSource>::New();
    line->SetPoint1(0, 0, 0);
    line->SetPoint2(1, 1, 1);

    tubeFilter = vtkSmartPointer<vtkTubeFilter>::New();
    tubeFilter->SetInputConnection(line->GetOutputPort());
    tubeFilter->SetRadius(.025);
    tubeFilter->SetNumberOfSides(50);
    tubeFilter->SetCapping(1);
    tubeFilter->Update();

    tubeMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    tubeMapper->SetInputConnection(tubeFilter->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(tubeMapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["tube"] = actor.Get();
}

QStringList TubeGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"tube"};
    else
        return {};
}

void TubeGeometry::setRadius(double radius)
{
    if (isnan(radius)) return;
    tubeFilter->SetRadius(radius);
    renderer->needUpdate();
}

void TubeGeometry::setPoint1X(double x)
{
    if (isnan(x)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void TubeGeometry::setPoint1Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void TubeGeometry::setPoint1Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], pt[1], z);
    renderer->needUpdate();
}

void TubeGeometry::setPoint2X(double x)
{
    if (isnan(x)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(x, pt[1], pt[2]);
    renderer->needUpdate();
}

void TubeGeometry::setPoint2Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], y, pt[2]);
    renderer->needUpdate();
}

void TubeGeometry::setPoint2Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], pt[1], z);
    renderer->needUpdate();
}
