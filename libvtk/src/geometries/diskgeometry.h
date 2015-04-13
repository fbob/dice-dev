#ifndef DISKGEOMETRY_H
#define DISKGEOMETRY_H

#include "geometrybase.h"

#include <vtkDiskSource.h>
#include <vtkTransformFilter.h>

class vtkQFBORenderer;

class DiskGeometry: public GeometryBase
{
    Q_OBJECT
public:
    explicit DiskGeometry(QObject* parent=0);
    QStringList actorPath(vtkActor *actor) override;

public slots:
    void setX(double x);
    void setY(double y);
    void setZ(double z);
    void setNormX(double nx);
    void setNormY(double ny);
    void setNormZ(double nz);
    void setRadius(double radius);

private:
    vtkSmartPointer<vtkDiskSource> disk;
    vtkSmartPointer<vtkTransformFilter> transformFilter;
    vtkSmartPointer<vtkActor> actor;
    double normal[3];
    void updateNormal();
    void setInitNormal();

protected:
    void createActors() override;
};

#endif // DISKGEOMETRY_H
