#include "openfoamloader.h"

#include <QDebug>

#include <vtkUnstructuredGrid.h>
#include <vtkLookupTable.h>
#include <vtkMultiBlockDataSet.h>
#include <vtkCellData.h>
#include <vtkPointData.h>
#include <vtkProperty.h>
#include <vtkDataObject.h>
#include <vtkPolyData.h>
#include <vtkDataSetSurfaceFilter.h>
#include <vtkQuadricLODActor.h>
#include <QMutexLocker>

OpenFOAMLoader::OpenFOAMLoader(QObject* parent) : LoaderBase(parent)
{

}

QList<QString> OpenFOAMLoader::getPatchNames()
{
    return {"min_X_Plane", "max_X_Plane", "min_Y_Plane", "max_Y_Plane", "min_Z_Plane", "max_Z_Plane", "zone0"};
}

QStringList OpenFOAMLoader::actorPath(vtkActor *actor)
{
    return {};
}

void OpenFOAMLoader::reload()
{

}

void OpenFOAMLoader::makeReader(const char *fileName)
{
    reader = vtkSmartPointer<vtkPOpenFOAMReader>::New();
    reader->SetCaseType(1);
    reader->SetFileName(fileName);

    reader->CreateCellToPointOn();
    reader->DisableAllCellArrays();
    reader->DisableAllLagrangianArrays();
    reader->DisableAllPointArrays();
    reader->DisableAllPatchArrays();

    reader->CacheMeshOff();

    reader->DecomposePolyhedraOn();

    reader->ReleaseDataFlagOn();

    for (QString patch: getPatchNames()) {
        reader->SetPatchArrayStatus(patch.toStdString().c_str(), 1);
    }

    // zones on
    reader->ReadZonesOn();

    reader->Update();

    vtkMultiBlockDataSet* dataSet = reader->GetOutput();

    int numOfBlocks = dataSet->GetNumberOfBlocks();
    qDebug() << "got"<< numOfBlocks << "blocks";

}

void OpenFOAMLoader::loadCellBlock()
{
}

void OpenFOAMLoader::createPatchActors(vtkDataObject *block)
{
    static bool first = true;
    if (block != nullptr && block->IsA("vtkMultiBlockDataSet")) {
        vtkMultiBlockDataSet* dataset = (vtkMultiBlockDataSet*) block;
        int subblockNumbers = dataset->GetNumberOfBlocks();
        qDebug() << "read" << subblockNumbers << "patches";
        int patchesCounter = 1;
        for (int i=0; i<subblockNumbers; i++) {
            vtkDataObject* subBlock = dataset->GetBlock(i);
            qDebug() << "got a" << subBlock->GetClassName();
            if (subBlock->IsA("vtkPolyData")) {

                    vtkSmartPointer<vtkDataSetSurfaceFilter> filter = vtkSmartPointer<vtkDataSetSurfaceFilter>::New();
                    filter->SetInputData(static_cast<vtkPolyData*>(subBlock));
                    filter->Update();


                    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
                    mapper->SetInputConnection(filter->GetOutputPort());

                    vtkQuadricLODActor* pActor = vtkQuadricLODActor::New();
                    pActor->SetDataConfigurationToXYZVolume();
                    pActor->SetMapper(mapper);
                    pActor->SetVisibility(1);
                    mapper->Update();

                    pActor->GetProperty()->SetAmbient(0.1);
                    pActor->GetProperty()->SetDiffuse(0.8);
                    pActor->GetProperty()->SetSpecular(0.1);

                QString patchName = reader->GetPatchArrayName(patchesCounter++);
                qDebug() << "got patch" << patchName;

                first = false;
                m_actors[patchName] = pActor;
            } else if (subBlock->IsA("vtkUnstructuredGrid")) {
            } else {
                if (subBlock->IsA("vtkMultiBlockDataSet")) {
                    createPatchActors(subBlock);
                }
            }
        }
    } else {
        if (block)
            qDebug() << "got a"<<block->GetClassName();
        else
            qDebug() << "got a null pointer";
    }
}

void OpenFOAMLoader::createActors()
{
    makeReader(fileName.toStdString().c_str());
    createPatchActors(reader->GetOutput());
}
