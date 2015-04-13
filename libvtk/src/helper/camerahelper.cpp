#include "camerahelper.h"

#include "vtkqfborenderer.h"

CameraHelper::CameraHelper(QObject* parent) : QObject(parent)
{
    qRenderer = qobject_cast<vtkQFBORenderer*>(parent);
}

CameraHelper::~CameraHelper()
{
}

void CameraHelper::setRenderer(vtkRenderer *renderer)
{
    this->renderer = renderer;
    this->camera = renderer->GetActiveCamera();
}

void CameraHelper::setPosition(double x, double y, double z)
{
    camera->SetPosition(x, y, z);
}

void CameraHelper::setViewUp(int x, int y, int z)
{
    camera->SetViewUp(x, y, z);
}

void CameraHelper::setFocalPoint(double x, double y, double z)
{
    camera->SetFocalPoint(x, y, z);
}

void CameraHelper::setParallelProjection(bool parallel)
{
    camera->SetParallelProjection(parallel);
}

void CameraHelper::resetCamera()
{
    renderer->ResetCamera();
}

void CameraHelper::update()
{
    qRenderer->needUpdate();
}

