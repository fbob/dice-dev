#ifndef CONEGEOMETRY_H
#define CONEGEOMETRY_H

#include "geometrybase.h"
#include <vtkConeSource.h>

class vtkQFBORenderer;

class ConeGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit ConeGeometry(QObject *parent = 0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setX(double x);
    void setY(double y);
    void setZ(double z);
    void setRadius(double radius);
    void setHeight(double height);
    void setDirectionX(double directionX);
    void setDirectionY(double directionY);
    void setDirectionZ(double directionZ);

private:
    vtkSmartPointer<vtkConeSource> cone;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
};

#endif // CONEGEOMETRY_H
