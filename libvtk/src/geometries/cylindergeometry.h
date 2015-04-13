#ifndef CYLINDERGEOMETRY_H
#define CYLINDERGEOMETRY_H

#include "geometrybase.h"

#include <vtkCylinderSource.h>

class vtkQFBORenderer;

class CylinderGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit CylinderGeometry(QObject *parent = 0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setX(double x);
    void setY(double y);
    void setZ(double z);
    void setRadius(double radius);
    void setHeight(double height);

private:
    vtkSmartPointer<vtkCylinderSource> cylinder;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
};

#endif // CYLINDERGEOMETRY_H

