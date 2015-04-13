#include "linegeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

LineGeometry::LineGeometry(QObject* parent) : GeometryBase(parent)
{
}

void LineGeometry::createActors()
{
    if (actor) return;

    line = vtkSmartPointer<vtkLineSource>::New();
    line->SetPoint1(0, 0, 0);
    line->SetPoint2(10, 10, 10);
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(line->GetOutputPort());

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    m_actors["line"] = actor.Get();
}

QStringList LineGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"line"};
    else
        return {};
}

void LineGeometry::setPoint1X(double x)
{
    if (isnan(x)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(x, pt[1], pt[2]);
}

void LineGeometry::setPoint1Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], y, pt[2]);
}

void LineGeometry::setPoint1Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint1();
    line->SetPoint1(pt[0], pt[1], z);
}

void LineGeometry::setPoint2X(double x)
{
    if (isnan(x)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(x, pt[1], pt[2]);
}

void LineGeometry::setPoint2Y(double y)
{
    if (isnan(y)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], y, pt[2]);
}

void LineGeometry::setPoint2Z(double z)
{
    if (isnan(z)) return;
    double* pt = line->GetPoint2();
    line->SetPoint2(pt[0], pt[1], z);
}
