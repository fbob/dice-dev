#ifndef QVTKFRAMEBUFFEROBJECTRENDERER_H
#define QVTKFRAMEBUFFEROBJECTRENDERER_H

#include "fborenderitem.h"
#include "vtkqmlrenderwindowinteractor.h"
#include "helper/camerahelper.h"

#include <QObject>
#include <QQuickFramebufferObject>
#include <QMutex>
#include <vtkSmartPointer.h>
#include <vtkRenderer.h>
#include <vtkAxesActor.h>
#include <vtkOrientationMarkerWidget.h>

class vtkQOpenGLRenderWindow;
class GeometryBase;

class vtkQFBORenderer: public QObject, public QQuickFramebufferObject::Renderer
{
    Q_OBJECT
    friend class ActorHelper;
public:
    explicit vtkQFBORenderer(vtkQOpenGLRenderWindow* rw);
    ~vtkQFBORenderer();

    void synchronize(QQuickFramebufferObject* item) override;
    void render() override;
    QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override;

    void needUpdate();

public slots:
    void mousePressed(int buttons);
    void mouseReleased(int buttons);
    void mouseMoved(int x, int y);
    void mouseWheel(int angle);
    void mouseClicked(int buttons, int x, int y);
    void keyPressed(int key);

    void setVisObjects(QVariantList objects);

signals:
    void boundariesChanged(double minX, double maxX, double minY, double maxY, double minZ, double maxZ);
    void pickedPatchChanged(QStringList patchPath);

    void loading(bool loading);

private:
    vtkSmartPointer<vtkRenderer> renderer;
    vtkQOpenGLRenderWindow *renderWindow = nullptr;
    QOpenGLFramebufferObject *fbo = nullptr;
    vtkSmartPointer<vtkQMLRenderWindowInteractor> renderWindowInteractor;

    int prevButtons = 0;
    bool ignoreMouseClick = false;
    int mouseX = 0, mouseY = 0;
    bool changed = false;

    void displayOrientationAxes();
    vtkSmartPointer<vtkAxesActor> axes;
    vtkSmartPointer<vtkOrientationMarkerWidget> orientationMarkerWidget;

    QMutex mutex;
    QVariantList patches;

    void destroy();

    void highlightPickedActor(vtkActor* pickedActor);
    vtkActor* lastPickedActor = nullptr;
    vtkProperty* lastPickedProperty;

    void sendPickedPatchSignal(vtkActor* pickedActor);

    void reload();

    QMap<GeometryBase*, QObject*> geometries; // mapping of the geometries to their wrappers

    CameraHelper cameraHelper;
    void connectCamera(QVariant app);
};

#endif // VTKQFBORENDERER_H
