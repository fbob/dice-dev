#ifndef MULTIPATCHBOXGEOMETRY_H
#define MULTIPATCHBOXGEOMETRY_H

#include "geometrybase.h"
#include <QMap>

class vtkQFBORenderer;
class vtkPlaneSource;

class MultiPatchBoxGeometry : public GeometryBase
{
    Q_OBJECT
public:
    explicit MultiPatchBoxGeometry(QObject *parent = 0);

    QStringList actorPath(vtkActor *actor) override;

    static QStringList patchNames;

signals:

public slots:
    void setMinX(double d);
    void setMaxX(double d);
    void setMinY(double d);
    void setMaxY(double d);
    void setMinZ(double d);
    void setMaxZ(double d);

    void setVisible(bool visible) override;

    void setResolutionX(int res);
    void setResolutionY(int res);
    void setResolutionZ(int res);

private:
    QMap<QString, vtkPlaneSource*> planes;

    bool visible = true;

    vtkActor* makeActor(QString patchName);

protected:
    void createActors() override;
};

#endif // MULTIPATCHBOXGEOMETRY_H
