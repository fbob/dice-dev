#ifndef CAMERAHELPER_H
#define CAMERAHELPER_H

#include <QObject>
#include <vtkCamera.h>
#include <vtkRenderer.h>

#include <QQuickWindow>


class vtkQFBORenderer;

class CameraHelper: public QObject
{
    Q_OBJECT

public:
    CameraHelper(QObject* parent=0);
    ~CameraHelper();

    void setRenderer(vtkRenderer* renderer);

public slots:
    void setPosition(double x, double y, double z);
    void setViewUp(int x, int y, int z);
    void setFocalPoint(double x, double y, double z);
    void setParallelProjection(bool parallel);

    void resetCamera();
    void update();

private:
    vtkCamera* camera;
    vtkRenderer* renderer;
    vtkQFBORenderer* qRenderer;
};

#endif // CAMERAHELPER_H
