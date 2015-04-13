#include "cone2Rgeometry.h"

#include "vtkqfborenderer.h"

#include <cmath>

#include <QDebug>

#include <vtkPolyDataMapper.h>
#include <vtkProperty.h>

// Based on: http://www.vtk.org/Wiki/VTK/Examples/Cxx/VisualizationAlgorithms/TubesFromSplines
// -------------------------------------------------------------------------------------------
Cone2RGeometry::Cone2RGeometry(QObject *parent) : GeometryBase(parent)
{
}

void Cone2RGeometry::createActors()
{
    if (actor) return;

    this->radius1 = 0.2;
    this->radius2 = 0.1;
    double point1[3] = {0, 0, 0};
    double point2[3] = {0, 0, 1};
    points = vtkSmartPointer<vtkPoints>::New();
    points->InsertPoint(0, point1[0], point1[1], point1[2]);
    points->InsertPoint(1, point2[0], point2[1], point2[2]);

    spline = vtkSmartPointer<vtkParametricSpline>::New();
    spline->SetPoints(points);

    // Interpolate the points
    functionSource = vtkSmartPointer<vtkParametricFunctionSource>::New();
    functionSource->SetParametricFunction(spline);
    functionSource->SetUResolution(2);
    functionSource->SetVResolution(2);
    functionSource->SetWResolution(2);
    functionSource->Update();

    // Interpolate the scalars
    double rad[1];
    interpolatedRadius = vtkSmartPointer<vtkTupleInterpolator>::New();
    interpolatedRadius->SetInterpolationTypeToLinear();
    interpolatedRadius->SetNumberOfComponents(1);
    rad[0] = this->radius1;
    interpolatedRadius->AddTuple(0,rad);
    rad[0] = this->radius2;
    interpolatedRadius->AddTuple(1,rad);

    // Generate the radius scalars
    tubeRadius = vtkSmartPointer<vtkDoubleArray>::New();
    tubeRadius->SetName("TubeRadius");
    unsigned int n = functionSource->GetOutput()->GetNumberOfPoints();
    tubeRadius->SetNumberOfTuples(n);
    double tMin = interpolatedRadius->GetMinimumT();
    double tMax = interpolatedRadius->GetMaximumT();
    double r[1];
    for (unsigned int i = 0; i < n; ++i)
    {
        double t = (tMax - tMin) / (n - 1) * i + tMin;
        interpolatedRadius->InterpolateTuple(t, r);
        tubeRadius->SetTuple1(i, r[0]);
    }

    polyData = vtkSmartPointer<vtkPolyData>::New();
    polyData = functionSource->GetOutput();
    polyData->GetPointData()->AddArray(tubeRadius);
    polyData->GetPointData()->SetActiveScalars("TubeRadius");


    // Create a tube (cylinder) around the line
    tubeFilter = vtkSmartPointer<vtkTubeFilter>::New();
    tubeFilter->SetInputData(polyData);
    tubeFilter->SetVaryRadiusToVaryRadiusByAbsoluteScalar();
    tubeFilter->SetRadius(.025);
    tubeFilter->SetNumberOfSides(50);
    tubeFilter->SetCapping(1);
    tubeFilter->Update();

    tubeMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    tubeMapper->SetInputConnection(tubeFilter->GetOutputPort());
    tubeMapper->ScalarVisibilityOff();

    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(tubeMapper);

    actor->GetProperty()->SetColor(0, 0, 0.6);
    actor->GetProperty()->SetOpacity(0.5);
    m_actors["cone2R"] = actor.Get();
}

QStringList Cone2RGeometry::actorPath(vtkActor *actor)
{
    if (actor == this->actor)
        return {"cone2R"};
    else
        return {};
}

void Cone2RGeometry::calculatePolyData() {
    // Interpolate the scalars
    double rad[1];
    interpolatedRadius->SetInterpolationTypeToLinear();
    interpolatedRadius->SetNumberOfComponents(1);
    rad[0] = this->radius1;
    interpolatedRadius->AddTuple(0,rad);
    rad[0] = this->radius2;
    interpolatedRadius->AddTuple(1,rad);

    // Generate the radius scalars
    tubeRadius->SetName("TubeRadius");
    unsigned int n = functionSource->GetOutput()->GetNumberOfPoints();
    tubeRadius->SetNumberOfTuples(n);
    double tMin = interpolatedRadius->GetMinimumT();
    double tMax = interpolatedRadius->GetMaximumT();
    double r[1];
    for (unsigned int i = 0; i < n; ++i)
    {
        double t = (tMax - tMin) / (n - 1) * i + tMin;
        interpolatedRadius->InterpolateTuple(t, r);
        tubeRadius->SetTuple1(i, r[0]);
    }

    polyData = functionSource->GetOutput();
    polyData->GetPointData()->AddArray(tubeRadius);
    polyData->GetPointData()->SetActiveScalars("TubeRadius");
}

void Cone2RGeometry::setRadius1(double radius1)
{
    if (isnan(radius1)) return;
    this->radius1 = radius1;
    this->update();
}

void Cone2RGeometry::setRadius2(double radius2)
{
    if (isnan(radius2)) return;
    this->radius2 = radius2;
    this->update();
}

void Cone2RGeometry::update() {
    spline->Modified();
    functionSource->Update();
    this->calculatePolyData();
    renderer->needUpdate();
}

void Cone2RGeometry::setPoint1X(double x)
{
    if (isnan(x)) return;
    qDebug() << "Point1X " << x;
    double* pt = points->GetPoint(0);
    points->SetPoint(0, x, pt[1], pt[2]);
    this->update();
}

void Cone2RGeometry::setPoint1Y(double y)
{
    if (isnan(y)) return;
    double* pt = points->GetPoint(0);
    points->SetPoint(0, pt[0], y, pt[2]);
    this->update();
}

void Cone2RGeometry::setPoint1Z(double z)
{
    if (isnan(z)) return;
    double* pt = points->GetPoint(0);
    points->SetPoint(0, pt[0], pt[1], z);
    this->update();
}

void Cone2RGeometry::setPoint2X(double x)
{
    if (isnan(x)) return;
    double* pt = points->GetPoint(1);
    points->SetPoint(1, x, pt[1], pt[2]);
    this->update();
}

void Cone2RGeometry::setPoint2Y(double y)
{
    if (isnan(y)) return;
    double* pt = points->GetPoint(1);
    points->SetPoint(1, pt[0], y, pt[2]);
    this->update();
}

void Cone2RGeometry::setPoint2Z(double z)
{
    if (isnan(z)) return;
    double* pt = points->GetPoint(1);
    points->SetPoint(1, pt[0], pt[1], z);
    this->update();
}
