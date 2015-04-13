#ifndef POINTGEOMETRY_H
#define POINTGEOMETRY_H

#include "geometrybase.h"

#include <vtkSphereSource.h>

class vtkQFBORenderer;

class PointGeometry: public GeometryBase
{
    Q_OBJECT
public:
    explicit PointGeometry(QObject* parent=0);
    QStringList actorPath(vtkActor *actor) override;


public slots:
    void setX(double x);
    void setY(double y);
    void setZ(double z);
    void setRadius(double radius);

private:
    vtkSmartPointer<vtkSphereSource> sphere;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
};

#endif // POINTGEOMETRY_H
