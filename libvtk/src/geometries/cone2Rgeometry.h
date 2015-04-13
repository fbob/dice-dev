#ifndef CONE2RGEOMETRY_H
#define CONE2RGEOMETRY_H

#include "geometrybase.h"

#include <vtkLineSource.h>
#include <vtkTubeFilter.h>

#include <vtkPolyDataMapper.h>
#include <vtkParametricFunctionSource.h>
#include <vtkTupleInterpolator.h>
#include <vtkDoubleArray.h>
#include <vtkParametricSpline.h>
#include <vtkPolyData.h>
#include <vtkPointData.h>

class Cone2RGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit Cone2RGeometry(QObject *parent=0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setPoint1X(double x);
    void setPoint1Y(double y);
    void setPoint1Z(double z);
    void setPoint2X(double x);
    void setPoint2Y(double y);
    void setPoint2Z(double z);
    void setRadius1(double radius1);
    void setRadius2(double radius2);

private:
    vtkSmartPointer<vtkLineSource> line;
    vtkSmartPointer<vtkTubeFilter> tubeFilter;
    vtkSmartPointer<vtkPoints> points;
    vtkSmartPointer<vtkParametricSpline> spline;
    vtkSmartPointer<vtkParametricFunctionSource> functionSource;
    vtkSmartPointer<vtkTupleInterpolator> interpolatedRadius;
    vtkSmartPointer<vtkDoubleArray> tubeRadius;
    vtkSmartPointer<vtkPolyData> polyData;
    vtkSmartPointer<vtkPolyDataMapper> tubeMapper;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
    void calculatePolyData();
    double radius1;
    double radius2;
    void update();
};

#endif // CONE2RGEOMETRY_H
