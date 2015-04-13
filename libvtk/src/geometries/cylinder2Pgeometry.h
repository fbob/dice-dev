#ifndef CYLINDER2PGEOMETRY_H
#define CYLINDER2PGEOMETRY_H

#include "geometrybase.h"

#include <vtkLineSource.h>
#include <vtkTubeFilter.h>

class vtkQFBORenderer;

class Cylinder2PGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit Cylinder2PGeometry(QObject *parent = 0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setPoint1X(double x);
    void setPoint1Y(double y);
    void setPoint1Z(double z);
    void setPoint2X(double x);
    void setPoint2Y(double y);
    void setPoint2Z(double z);
    void setRadius(double radius);

private:
    vtkSmartPointer<vtkLineSource> line;
    vtkSmartPointer<vtkTubeFilter> tubeFilter;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
};

#endif // CYLINDER2PGEOMETRY_H

