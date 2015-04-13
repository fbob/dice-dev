#ifndef OPENFOAMLOADER_H
#define OPENFOAMLOADER_H

#include "loaderbase.h"
#include <QFileInfo>
#include <QMap>

#include <vtkPOpenFOAMReader.h>
class vtkUnstructuredGrid;

class OpenFOAMLoader : public LoaderBase
{
    Q_OBJECT
public:
    OpenFOAMLoader(QObject* parent=nullptr);
    QList<QString> getPatchNames();
    QStringList actorPath(vtkActor *actor) override;
    void reload() override;

private:
    vtkSmartPointer<vtkPOpenFOAMReader> reader;

    void makeReader(const char* fileName);
    void loadCellBlock();
    void createPatchActors(vtkDataObject *block);

protected:
    void createActors() override;
};

#endif // OPENFOAMLOADER_H
