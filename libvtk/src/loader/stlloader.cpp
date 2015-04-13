#include "stlloader.h"
#include <clocale>
#include <QMutexLocker>
#include <vtkProperty.h>
#include <QDebug>
#include <QFileInfo>

STLLoader::STLLoader(QObject* parent) : LoaderBase(parent)
{
}

STLLoader::~STLLoader()
{

}

void STLLoader::createActors()
{
    QMutexLocker locker{&loaderMutex};
    if (actor) return;

    // set locale to C to work correctly with dots as decimal limiters
    setlocale(LC_ALL, "C");

    reader = vtkSmartPointer<vtkSTLReader>::New();
    reader->SetFileName(fileName.toStdString().c_str());
//    reader->ScalarTagsOn();
    reader->Update();
    mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
//    mapper->SetInputData(reader->GetOutput());
    mapper->SetInputConnection(reader->GetOutputPort());
//    actor = createDefaultActor(mapper);
    actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
//    actor->Set

//    actor->GetProperty()->SetColor(0.5, 0.5, 1.0);
//    actor->GetProperty()->SetEdgeColor(0.1, 0.1, 1);
//    actor->GetProperty()->BackfaceCullingOn();

    QString relativeFileName = "zone0"; // TODO: read regions
    m_actors[relativeFileName] = actor.Get();
}

QStringList STLLoader::actorPath(vtkActor *actor)
{
    return {};
}

void STLLoader::reload()
{
    reader = vtkSmartPointer<vtkSTLReader>::New();
    reader->SetFileName(fileName.toStdString().c_str());
    mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(reader->GetOutputPort());
    actor->SetMapper(mapper);
}
