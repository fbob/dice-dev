#include "vtkqfborenderer.h"

#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkInteractorStyleSwitch.h>
#include <vtkCamera.h>

#include <QOpenGLFramebufferObjectFormat>
#include <QOpenGLFunctions>

#include <QQuickWindow>

#include "geometries/pointgeometry.h"
#include "geometries/boxgeometry.h"
#include "geometries/multipatchboxgeometry.h"
#include "geometries/cylindergeometry.h"
#include "geometries/conegeometry.h"
#include "geometries/cone2Rgeometry.h"
#include "geometries/planegeometry.h"
#include "geometries/spheregeometry.h"
#include "geometries/linegeometry.h"
#include "geometries/diskgeometry.h"
#include "geometries/tubegeometry.h"

#include "loader/stlloader.h"
#include "loader/openfoamloader.h"

#include "vtkqmlinteractorstyleswitch.h"
#include "vtkqopenglrenderwindow.h"


vtkQFBORenderer::vtkQFBORenderer(vtkQOpenGLRenderWindow *rw) :
    renderWindow(rw),
    fbo(nullptr),
    cameraHelper(this)
{
    renderWindow->Register(NULL);
    renderWindow->fboRenderer = this;

    renderer = vtkSmartPointer<vtkRenderer>::New();
    renderWindow->AddRenderer(renderer);
    renderWindowInteractor = vtkSmartPointer<vtkQMLRenderWindowInteractor>::New();
    renderWindowInteractor->SetRenderWindow(renderWindow);
    renderWindowInteractor->setDefaultRenderer(renderer);

    vtkQMLInteractorStyleSwitch* style = vtkQMLInteractorStyleSwitch::New();
    style->SetDefaultRenderer(renderer);

    renderWindowInteractor->SetInteractorStyle(style);
    style->Delete(); // no longer needed here, stays in renderWindowInteractor
    renderWindowInteractor->Start();

    renderer->ResetCamera();

    lastPickedProperty = vtkProperty::New();
    cameraHelper.setRenderer(renderer);

    connect(style, &vtkQMLInteractorStyleSwitch::pickedActorChanged, this, &vtkQFBORenderer::sendPickedPatchSignal);
}

vtkQFBORenderer::~vtkQFBORenderer()
{
    qDebug() << "vtkQFBORenderer destroyed";
    if (renderWindow)
        renderWindow->fboRenderer = nullptr;

    for (GeometryBase* g: geometries.keys())
        g->deleteLater();

    lastPickedProperty->Delete();
}

void vtkQFBORenderer::synchronize(QQuickFramebufferObject * item)
{
    if (!fbo)
    {
        FBORenderItem *vtkItem = static_cast<FBORenderItem*>(item);

        // every connection here must be Qt::QueuedConnection since it's called from another thread

        connect(vtkItem, &FBORenderItem::mouseMoved, vtkItem->window(), &QQuickWindow::update, Qt::QueuedConnection); // little overkill, but needed for threaded rendering

        connect(vtkItem, &FBORenderItem::mousePressed, this, &vtkQFBORenderer::mousePressed, Qt::QueuedConnection);
        connect(vtkItem, &FBORenderItem::mouseReleased, this, &vtkQFBORenderer::mouseReleased, Qt::QueuedConnection);
        connect(vtkItem, &FBORenderItem::mouseMoved, this, &vtkQFBORenderer::mouseMoved, Qt::QueuedConnection);
        connect(vtkItem, &FBORenderItem::mouseClicked, this, &vtkQFBORenderer::mouseClicked, Qt::QueuedConnection);
        connect(vtkItem, &FBORenderItem::mouseWheel, this, &vtkQFBORenderer::mouseWheel, Qt::QueuedConnection);
        connect(vtkItem, &FBORenderItem::keyPressed, this, &vtkQFBORenderer::keyPressed, Qt::QueuedConnection);

        connect(vtkItem, &FBORenderItem::destroyed, this, &vtkQFBORenderer::destroy);

        connect(vtkItem, &FBORenderItem::reload, this, &vtkQFBORenderer::reload, Qt::QueuedConnection);

        connect(this, &vtkQFBORenderer::loading, vtkItem, &FBORenderItem::setLoading, Qt::QueuedConnection);

        connect(vtkItem, &FBORenderItem::visObjectsChanged, this, &vtkQFBORenderer::setVisObjects, Qt::QueuedConnection);
        this->setVisObjects(vtkItem->visObjects());

        connect(vtkItem, &FBORenderItem::appChanged, this, &vtkQFBORenderer::connectCamera, Qt::QueuedConnection);
        connectCamera(vtkItem->app());

        displayOrientationAxes();
    }
}

void vtkQFBORenderer::render()
{
    QMutexLocker locker{&mutex};
    renderWindow->PushState();
    renderWindow->OpenGLInitState();
    renderWindow->render();
    renderWindow->PopState();
}

QOpenGLFramebufferObject *vtkQFBORenderer::createFramebufferObject(const QSize &size)
{
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::Depth);
    fbo = new QOpenGLFramebufferObject(size, format);

    renderWindow->setFBO(fbo);
    int rsize[] = {size.width(), size.height()};
    renderWindowInteractor->SetSize(rsize);

    return fbo;
}

void vtkQFBORenderer::needUpdate()
{
    update();
}

void vtkQFBORenderer::mousePressed(int buttons) {
    if (buttons & Qt::LeftButton)
        renderWindowInteractor->mouseLeftPressed();

    if (buttons & Qt::RightButton)
        renderWindowInteractor->mouseRightPressed();

    if (buttons & Qt::MiddleButton)
        renderWindowInteractor->mouseMiddlePressed();

    prevButtons = buttons;
    ignoreMouseClick = false;
    update();
}

void vtkQFBORenderer::mouseReleased(int buttons) {
    int releasedButtons = (prevButtons & (~buttons));

    if (releasedButtons & Qt::LeftButton)
        renderWindowInteractor->mouseLeftReleased();

    if (releasedButtons & Qt::RightButton)
        renderWindowInteractor->mouseRightReleased();

    if (releasedButtons & Qt::MiddleButton)
        renderWindowInteractor->mouseMiddleReleased();

    prevButtons = buttons;
    update();
}

void vtkQFBORenderer::mouseMoved(int x, int y) {
    renderWindowInteractor->mouseMoved(x, y);
    // ignore the following mouse click event if the mouse have moved more than 5 pixels in any direction
    if (abs(mouseX-x) > 5 || abs(mouseY-y) > 5)
        ignoreMouseClick = true;
    mouseX = x;
    mouseY = y;
//    update();
}

void vtkQFBORenderer::mouseWheel(int angle) {
    renderWindowInteractor->mouseWheel(angle);
    update();
}

void vtkQFBORenderer::mouseClicked(int buttons, int x, int y) {
    Q_UNUSED(buttons)
    Q_UNUSED(x)
    Q_UNUSED(y)
    if (ignoreMouseClick) return;
    update();
}

void vtkQFBORenderer::keyPressed(int key) {
    renderWindowInteractor->keyPressed(key);
    update();
}

void vtkQFBORenderer::setVisObjects(QVariantList objects)
{
    qDebug() << "setVisObjects" << objects;
    QList<QObject*> oList;

    oList.reserve(objects.size());
    for (QVariant var: objects) {
        QObject* o = qvariant_cast<QObject*>(var);
        if (o) {
            oList.append(o);
            QString className = o->metaObject()->className();
            GeometryBase* geometry = nullptr;
            LoaderBase* loader = nullptr;

            if (className == "BoxWrapper") {
                geometry = new BoxGeometry{this};
            } else if (className == "PointWrapper") {
                geometry = new PointGeometry{this};
            } else if (className == "MultiPatchBoxWrapper") {
                geometry = new MultiPatchBoxGeometry{this};
            } else if (className == "CylinderWrapper") {
                geometry = new CylinderGeometry{this};
            } else if (className == "ConeWrapper") {
                geometry = new ConeGeometry{this};
            } else if (className == "Cone2RWrapper") {
                geometry = new Cone2RGeometry{this};
            } else if (className == "PlaneWrapper") {
                geometry = new PlaneGeometry{this};
            } else if (className == "SphereWrapper") {
                geometry = new SphereGeometry{this};
            } else if (className == "LineWrapper") {
                geometry = new LineGeometry{this};
            } else if (className == "DiskWrapper") {
                geometry = new DiskGeometry{this};
            } else if (className == "TubeWrapper") {
                geometry = new TubeGeometry{this};
            } else if (className == "STLLoader") {
                loader = new STLLoader{this};
            } else if (className == "FoamMeshLoader") {
                loader = new OpenFOAMLoader{this};
            } else {
                qDebug() << "unknown geometry type:" << className;
            }

            QList<QObject*> wrapperList = geometries.values();

            if (geometry && !wrapperList.contains(o)) {
                for (vtkActor* actor: geometry->actors().values())
                    renderer->AddActor(actor);
                geometries[geometry] = o;
                QMetaObject::invokeMethod(o, "connectWith", Qt::QueuedConnection, Q_ARG(QObject*, geometry));
            } else if (loader && !wrapperList.contains(o)) {
                geometries[loader] = o;
                // For LoaderBase types we need to connect first, so the fileName is set. Only then we can get the actor.
                // The method call must happen trough a DirectConnection for the next code to block until the invokation is finished.
                QMetaObject::invokeMethod(o, "connectWith", Qt::DirectConnection, Q_ARG(QObject*, loader));
                for (vtkActor* actor: loader->actors().values())
                    renderer->AddActor(actor);
            }
        }

        qDebug() << "geometries " << geometries;
    }

    // remove the vis objects that are not in the input list
    for (GeometryBase* geometry: geometries.keys()) {
        QObject* wrapper = geometries[geometry];
        if (!oList.contains(wrapper)) {
            for (vtkActor* actor: geometry->actors().values())
                renderer->RemoveActor(actor);
            geometries.remove(geometry);
            geometry->deleteLater();
            update();
        }
    }
//    renderer->ResetCamera();
}

void vtkQFBORenderer::displayOrientationAxes()
{
    if (!renderWindowInteractor || axes) return;

    axes = vtkSmartPointer<vtkAxesActor>::New();
    orientationMarkerWidget = vtkSmartPointer<vtkOrientationMarkerWidget>::New();
    orientationMarkerWidget->SetOrientationMarker( axes );

    orientationMarkerWidget->SetInteractor( renderWindowInteractor );
    orientationMarkerWidget->SetViewport( 0.0, 0.0, 0.3, 0.3 );
    orientationMarkerWidget->SetEnabled( 1 );
    orientationMarkerWidget->InteractiveOff();
    axes->Delete();

    renderer->ResetCamera();
}

void vtkQFBORenderer::destroy()
{
    qDebug() << "FBO is destroyed";
    this->renderer->RemoveAllViewProps();
    this->renderWindow->RemoveRenderer(this->renderer);
    this->deleteLater();
}

void vtkQFBORenderer::highlightPickedActor(vtkActor *pickedActor)
{
    if (lastPickedActor) {
        lastPickedActor->GetProperty()->DeepCopy(lastPickedProperty);
    }
    lastPickedActor = pickedActor;
    if (lastPickedActor) {
        lastPickedProperty->DeepCopy(lastPickedActor->GetProperty());
        lastPickedActor->GetProperty()->SetColor(1.0, 0.0, 0.0);
        lastPickedActor->GetProperty()->SetDiffuse(1.0);
        lastPickedActor->GetProperty()->SetSpecular(0.0);
    }
}

void vtkQFBORenderer::sendPickedPatchSignal(vtkActor* pickedActor)
{
    for (GeometryBase* geometry: geometries.keys()) {
        for (vtkActor* actor: geometry->actors()) {
            if (actor == pickedActor) {
                auto ap = geometry->actorPath(actor);
                qDebug() << ap;
                emit pickedPatchChanged(ap);
                return;
            }
        }
    }

    qDebug() << "unknown actor" << pickedActor;
    emit pickedPatchChanged({});
}

void vtkQFBORenderer::reload()
{

}

void vtkQFBORenderer::connectCamera(QVariant app)
{
    QObject* o = qvariant_cast<QObject*>(app);
    if (o) {
        QMetaObject::invokeMethod(o, "connectCamera", Qt::DirectConnection, Q_ARG(QObject*, &cameraHelper));
    }
}
