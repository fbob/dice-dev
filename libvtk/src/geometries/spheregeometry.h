#ifndef SPHEREGEOMETRY_H
#define SPHEREGEOMETRY_H

#include "geometrybase.h"

#include <vtkSphereSource.h>

class vtkQFBORenderer;

class SphereGeometry: public GeometryBase
{
    Q_OBJECT
public:
    explicit SphereGeometry(QObject* parent=0);
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

#endif // SPHEREGEOMETRY_H
