#include "vtkqmlinteractorstyleswitch.h"
#include <vtkObjectFactory.h>
#include <vtkPropPicker.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkSmartPointer.h>
#include <vtkActor.h>
#include <vtkCellPicker.h>
#include <vtkProp3D.h>

#include <QDebug>

vtkStandardNewMacro(vtkQMLInteractorStyleSwitch)

vtkQMLInteractorStyleSwitch::vtkQMLInteractorStyleSwitch()
{

}

vtkQMLInteractorStyleSwitch::~vtkQMLInteractorStyleSwitch()
{

}

void vtkQMLInteractorStyleSwitch::OnLeftButtonUp()
{
    if (!mouseMoved) {
        int* clickPos = this->GetInteractor()->GetEventPosition();
        vtkSmartPointer<vtkCellPicker> cp = vtkSmartPointer<vtkCellPicker>::New();
        cp->Pick(clickPos[0], clickPos[1], 0.0, this->GetDefaultRenderer());
        vtkProp* prop = cp->GetViewProp();
        if (prop != nullptr) {
            vtkActor* actor = vtkActor::SafeDownCast(prop);
            if (lastPickedActor != actor) {
                lastPickedActor = actor;
                emit pickedActorChanged(lastPickedActor);
            }
        } else {
            if (lastPickedActor != nullptr) {
                lastPickedActor = nullptr;
                emit pickedActorChanged(lastPickedActor);
            }
        }
    }

    vtkInteractorStyleTrackballCamera::OnLeftButtonUp();
}

void vtkQMLInteractorStyleSwitch::OnMouseMove()
{
    moveCounter++;
    if (moveCounter > MOVE_THRESHOLD) {
        mouseMoved = true;
        moveCounter = 0;
    }
    vtkInteractorStyleTrackballCamera::OnMouseMove();
}

void vtkQMLInteractorStyleSwitch::OnLeftButtonDown()
{
    mouseMoved = false;
    moveCounter = 0;
    vtkInteractorStyleTrackballCamera::OnLeftButtonDown();
}
