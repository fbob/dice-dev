#include "vtkqmlrenderwindowinteractor.h"
#include "vtkObjectFactory.h"
#include "vtkCommand.h"

//#include "vtkInteractorStyleTrackball.h"

#include <vtkPropPicker.h>
#include <vtkWorldPointPicker.h>
#include <vtkRenderWindow.h>
#include <vtkRenderer.h>

#include <QDebug>

vtkStandardNewMacro(vtkQMLRenderWindowInteractor);

vtkQMLRenderWindowInteractor::vtkQMLRenderWindowInteractor() : QObject(0), vtkRenderWindowInteractor()
{
//    this->SetInteractorStyle(vtkInteractorStyleTrackball::New());
    QObject::connect(&signalMapper, SIGNAL(mapped(int)), this, SLOT(vtkTimerEvent(int)) );
//    QObject::connect(&signalMapper, &QSignalMapper::mapped, this, &vtkQMLRenderWindowInteractor::vtkTimerEvent);
}

vtkQMLRenderWindowInteractor::~vtkQMLRenderWindowInteractor()
{
    this->Disable();
}

int vtkQMLRenderWindowInteractor::InternalCreateTimer(int timerId, int vtkNotUsed(timerType), unsigned long duration)
{
    duration = (duration > 0 ? duration : this->TimerDuration);

    QTimer* t = new QTimer{this};
    t->start(duration);
    signalMapper.setMapping(t, timerId);
    QObject::connect(t, SIGNAL(timeout()), &signalMapper, SLOT(map()), Qt::DirectConnection);
    int id = t->timerId();
    timers.insert(id, t);
    return id;
}

int vtkQMLRenderWindowInteractor::InternalDestroyTimer(int platformTimerId)
{
    QTimer* t = timers[platformTimerId];
    if (t != nullptr) {
        t->stop();
        disconnect(t, SIGNAL(timeout()), this, SLOT(vtkTimerEvent()));
        timers.remove(platformTimerId);
    }
    return 1;
}

void vtkQMLRenderWindowInteractor::updatePickedActor()
{
    if (!defaultRenderer) return;
    int* clickPos = this->GetEventPosition();
    qDebug() << "pick" << clickPos[0] << clickPos[1];
    vtkSmartPointer<vtkWorldPointPicker> wp = vtkSmartPointer<vtkWorldPointPicker>::New();
    vtkSmartPointer<vtkPropPicker> picker = vtkSmartPointer<vtkPropPicker>::New();
    wp->Pick(clickPos[0], clickPos[1], 0, defaultRenderer);
    vtkPropCollection* props = wp->GetPickList();
    props->InitTraversal();
    vtkProp* p = props->GetNextProp();
    double* sp = wp->GetPickPosition();
    qDebug() << sp[0] << sp[1] << sp[2];

    qDebug() << 1 << p;
    picker->Pick(clickPos[0], clickPos[1], 0, defaultRenderer);
    qDebug() << 2;
//    if (this->lastPickedActor) {
//        this->lastPickedActor->GetProperty()->DeepCopy(this->lastPickedProperty);
//    }
    vtkActor* actor = picker->GetActor();
    qDebug() << "actor" << actor;
    if (actor != this->lastPickedActor) {
        lastPickedActor = actor;
        emit pickedActorChanged(lastPickedActor);
    }
//    if (this->lastPickedActor) {
//        this->lastPickedProperty->DeepCopy(this->lastPickedActor->GetProperty());
//    }
}

void vtkQMLRenderWindowInteractor::mouseLeftPressed()
{
//    updatePickedActor();
    invokeMouseEvent(vtkCommand::LeftButtonPressEvent);
}

void vtkQMLRenderWindowInteractor::mouseLeftReleased()
{
    invokeMouseEvent(vtkCommand::LeftButtonReleaseEvent);
}

void vtkQMLRenderWindowInteractor::mouseRightPressed()
{
    invokeMouseEvent(vtkCommand::RightButtonPressEvent);
}

void vtkQMLRenderWindowInteractor::mouseRightReleased()
{
    invokeMouseEvent(vtkCommand::RightButtonReleaseEvent);
}

void vtkQMLRenderWindowInteractor::mouseMiddlePressed()
{
    invokeMouseEvent(vtkCommand::MiddleButtonPressEvent);
}

void vtkQMLRenderWindowInteractor::mouseMiddleReleased()
{
    invokeMouseEvent(vtkCommand::MiddleButtonReleaseEvent);
}

void vtkQMLRenderWindowInteractor::mouseMoved(int x, int y)
{
    if (!this->Enabled) return;
    mouseX = x;
    mouseY = y;
    this->SetEventInformation(x, y, ctrlPressed, shiftPressed);
    this->SetAltKey(altPressed);
    this->InvokeEvent(vtkCommand::MouseMoveEvent, NULL);
}

void vtkQMLRenderWindowInteractor::mouseWheel(int angle)
{
    if (angle > 0)
        invokeMouseEvent(vtkCommand::MouseWheelForwardEvent);
    else
        invokeMouseEvent(vtkCommand::MouseWheelBackwardEvent);
}

void vtkQMLRenderWindowInteractor::keyPressed(int key)
{
    char keyCode = (char) key;
    this->SetEventInformation(mouseX, mouseY, ctrlPressed, shiftPressed, keyCode);
    this->SetAltKey(altPressed);
    this->InvokeEvent(vtkCommand::KeyPressEvent, NULL);
    this->InvokeEvent(vtkCommand::CharEvent, NULL);
}

void vtkQMLRenderWindowInteractor::keyReleased(int key)
{
    char keyCode = (char) key;
    this->SetEventInformation(mouseX, mouseY, ctrlPressed, shiftPressed, keyCode);
    this->SetAltKey(altPressed);
    this->InvokeEvent(vtkCommand::KeyReleaseEvent, NULL);
}

void vtkQMLRenderWindowInteractor::GetMousePosition(int *x, int *y)
{
    *x = mouseX;
    *y = mouseY;
}

void vtkQMLRenderWindowInteractor::setDefaultRenderer(vtkSmartPointer<vtkRenderer> renderer)
{
    defaultRenderer = renderer;
}

void vtkQMLRenderWindowInteractor::vtkTimerEvent(int timerId)
{
    if (this->GetEnabled())
    {
        this->InvokeEvent(vtkCommand::TimerEvent,&timerId);
    }

    if (this->IsOneShotTimer(timerId)) {
        this->DestroyTimer(timerId);
    }
}

void vtkQMLRenderWindowInteractor::invokeMouseEvent(int event)
{
    this->SetEventInformation(mouseX, mouseY, ctrlPressed, shiftPressed);
    this->SetAltKey(altPressed);
    this->InvokeEvent(event, NULL);
}

