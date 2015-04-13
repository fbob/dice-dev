#ifndef VTKQMLINTERACTORSTYLESWITCH_H
#define VTKQMLINTERACTORSTYLESWITCH_H

#include <vtkInteractorStyleSwitch.h>
#include <vtkInteractorStyleTrackballCamera.h>
#include <vtkInteractorStyleTrackballActor.h>

#include <vtkActor.h>
#include <QObject>

#define MOVE_THRESHOLD 5

class vtkQMLInteractorStyleSwitch: public QObject, public vtkInteractorStyleTrackballCamera
{
    Q_OBJECT
public:
    static vtkQMLInteractorStyleSwitch *New();
    vtkTypeMacro(vtkQMLInteractorStyleSwitch, vtkInteractorStyleTrackballCamera)

    virtual void OnLeftButtonDown() override;
    virtual void OnLeftButtonUp() override;
    virtual void OnMouseMove() override;
signals:
    void pickedActorChanged(vtkActor* pickedActor);

protected:
    vtkQMLInteractorStyleSwitch();
    ~vtkQMLInteractorStyleSwitch();

private:
    vtkActor* lastPickedActor = nullptr;
    bool mouseMoved = false;
    quint32 moveCounter = 0;
};

#endif // VTKQMLINTERACTORSTYLESWITCH_H
