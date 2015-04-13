#ifndef PLANEGEOMETRY_H
#define PLANEGEOMETRY_H

#include "geometrybase.h"

#include <vtkPlaneSource.h>

class vtkQFBORenderer;

class PlaneGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit PlaneGeometry(QObject *parent = 0);
    QStringList actorPath(vtkActor *actor) override;


public slots:
    void setX(double x);
    void setY(double y);
    void setZ(double z);

    void setOriginX(double x);
    void setOriginY(double y);
    void setOriginZ(double z);

    void setPoint1X(double x);
    void setPoint1Y(double y);
    void setPoint1Z(double z);

    void setPoint2X(double x);
    void setPoint2Y(double y);
    void setPoint2Z(double z);

private:
    vtkSmartPointer<vtkPlaneSource> plane;
    vtkSmartPointer<vtkActor> actor;

protected:
    void createActors() override;
};

#endif // PLANEGEOMETRY_H
