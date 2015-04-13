#ifndef LINEGEOMETRY_H
#define LINEGEOMETRY_H

#include "geometrybase.h"

#include <vtkLineSource.h>


class LineGeometry: public GeometryBase
{
    Q_OBJECT
public:
    explicit LineGeometry(QObject* parent=0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setPoint1X(double x);
    void setPoint1Y(double y);
    void setPoint1Z(double z);
    void setPoint2X(double x);
    void setPoint2Y(double y);
    void setPoint2Z(double z);

protected:
    vtkSmartPointer<vtkLineSource> line;
    vtkSmartPointer<vtkActor> actor;
    void createActors() override;
};

#endif // LINEGEOMETRY_H
