#ifndef TUBEGEOMETRY_H
#define TUBEGEOMETRY_H

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

class TubeGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit TubeGeometry(QObject *parent=0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setPoint1X(double x);
    void setPoint1Y(double y);
    void setPoint1Z(double z);
    void setPoint2X(double x);
    void setPoint2Y(double y);
    void setPoint2Z(double z);
    void setRadius(double radius);

protected:
    vtkSmartPointer<vtkLineSource> line;
    vtkSmartPointer<vtkTubeFilter> tubeFilter;
    vtkSmartPointer<vtkActor> actor;
    vtkSmartPointer<vtkPoints> points;
    vtkSmartPointer<vtkParametricSpline> spline;
    vtkSmartPointer<vtkParametricFunctionSource> functionSource;
    vtkSmartPointer<vtkTupleInterpolator> interpolatedRadius;
    vtkSmartPointer<vtkDoubleArray> tubeRadius;
    vtkSmartPointer<vtkPolyData> polyData;
    vtkSmartPointer<vtkPolyDataMapper> tubeMapper;
    void createActors() override;
    void calculatePolyData();
    double radius;
    void update();
};

#endif // TUBEGEOMETRY_H
