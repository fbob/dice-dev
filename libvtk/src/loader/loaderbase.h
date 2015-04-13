#ifndef FORMATBASE_H
#define FORMATBASE_H

#include <QObject>
#include <QString>
#include <QMutex>
#include <QMap>
#include <vtkSmartPointer.h>
#include <vtkActor.h>
#include <vtkPolyDataMapper.h>
#include <vtkDataSetMapper.h>

#include "geometries/geometrybase.h"

class LoaderBase: public GeometryBase
{
    Q_OBJECT
public:
    LoaderBase(QObject* parent=nullptr);
    virtual ~LoaderBase();
    virtual void reload() = 0;

public slots:
    void setFileName(QString fileName);

protected:
    QString fileName;
    QMutex loaderMutex; // use this mutex when loading the file to prevent multiple calls
    vtkSmartPointer<vtkActor> createDefaultActor(vtkSmartPointer<vtkPolyDataMapper> mapper);
    vtkSmartPointer<vtkActor> createDefaultActor(vtkSmartPointer<vtkDataSetMapper> mapper);

    virtual void createActors() override = 0;
};

#endif // FORMATBASE_H
