#include "loaderbase.h"
#include <vtkProperty.h>
#include <QDebug>

LoaderBase::LoaderBase(QObject* parent) : GeometryBase(parent)
{
}

LoaderBase::~LoaderBase()
{
}

void LoaderBase::setFileName(QString fileName)
{
    qDebug() << "fileName:" << fileName;
    this->fileName = fileName;
}

vtkSmartPointer<vtkActor> LoaderBase::createDefaultActor(vtkSmartPointer<vtkPolyDataMapper> mapper)
{
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();

    actor->SetMapper(mapper);

    actor->GetProperty()->FrontfaceCullingOn();
    actor->GetProperty()->BackfaceCullingOn();
    actor->GetProperty()->SetRepresentationToSurface();
    actor->GetProperty()->EdgeVisibilityOff();

    vtkProperty *lut = actor->MakeProperty();

    lut->SetSpecular(0.0);
    lut->SetDiffuse(0.0);
    lut->SetAmbient(1.0);
    lut->SetAmbientColor(1.0000, 0.3882, 0.2784);
    lut->SetOpacity(0.0);
    actor->SetBackfaceProperty(lut);
    lut->Delete();
    actor->GetBackfaceProperty()->FrontfaceCullingOn();
    actor->GetBackfaceProperty()->BackfaceCullingOn();
    actor->GetBackfaceProperty()->SetRepresentationToWireframe();

    return actor;
}

vtkSmartPointer<vtkActor> LoaderBase::createDefaultActor(vtkSmartPointer<vtkDataSetMapper> mapper)
{
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->FrontfaceCullingOff();
    actor->GetProperty()->BackfaceCullingOn();
    actor->GetProperty()->SetRepresentationToSurface();
    actor->GetProperty()->EdgeVisibilityOff();

    vtkProperty *lut = actor->MakeProperty();

    lut->SetSpecular(0.0);
    lut->SetDiffuse(0.0);
    lut->SetAmbient(1.0);
    lut->SetAmbientColor(1.0000, 0.3882, 0.2784);
    lut->SetOpacity(0.0);
    actor->SetBackfaceProperty(lut);
    lut->Delete();
    actor->GetBackfaceProperty()->FrontfaceCullingOn();
    actor->GetBackfaceProperty()->BackfaceCullingOn();
    actor->GetBackfaceProperty()->SetRepresentationToWireframe();

//    addPatchActor(internalMeshActor, "internalMesh");
    return actor;
}
