#ifndef STLFORMAT_H
#define STLFORMAT_H

#include "loaderbase.h"
#include <vtkSTLReader.h>
#include <QFileInfo>

class STLLoader: public LoaderBase
{
    Q_OBJECT
public:
    STLLoader(QObject* parent=nullptr);
    ~STLLoader();
    QStringList actorPath(vtkActor *actor) override;
    void reload() override;

private:
     vtkSmartPointer<vtkSTLReader> reader;
     vtkSmartPointer<vtkPolyDataMapper> mapper;
     vtkSmartPointer<vtkActor> actor;

protected:
     void createActors() override;
};

#endif // STLFORMAT_H
