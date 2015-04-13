#ifndef GEOMETRYBASE_H
#define GEOMETRYBASE_H

#include <QObject>
#include <QMap>

#include <vtkSmartPointer.h>
#include <vtkActor.h>

class vtkQFBORenderer;

class GeometryBase : public QObject
{
    Q_OBJECT
public:
    GeometryBase(QObject* parent=0);
    virtual ~GeometryBase();
    virtual QMap<QString, vtkActor*> actors();
    virtual QStringList actorPath(vtkActor* actor) = 0;

public slots:
    virtual void setVisible(bool visible);
    virtual void setRepresentation(QString representation);

protected:
    vtkQFBORenderer* renderer;
    QMap<QString, vtkActor*> m_actors;

    virtual void createActors() = 0;
};

#endif // GEOMETRYBASE_H
