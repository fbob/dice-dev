#ifndef BOXGEOMETRY_H
#define BOXGEOMETRY_H

#include "geometrybase.h"
#include <vtkCubeSource.h>

class vtkQFBORenderer;

class BoxGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit BoxGeometry(QObject *parent = 0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setMinX(double d);
    void setMaxX(double d);
    void setMinY(double d);
    void setMaxY(double d);
    void setMinZ(double d);
    void setMaxZ(double d);

    void setCenterX(double x);
    void setCenterY(double y);
    void setCenterZ(double z);
    void setXLength(double xlength);
    void setYLength(double ylength);
    void setZLength(double zlength);
private:
    vtkSmartPointer<vtkCubeSource> cube;
    vtkSmartPointer<vtkActor> actor;

    double minX, maxX, minY, maxY, minZ, maxZ;

protected:
    void createActors() override;
};

#endif // BOXGEOMETRY_H
