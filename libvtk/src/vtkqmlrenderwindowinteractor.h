#ifndef VTKQMLRENDERWINDOWINTERACTOR_H
#define VTKQMLRENDERWINDOWINTERACTOR_H

#include <vtkRenderWindowInteractor.h>
#include <vtkSmartPointer.h>
#include <vtkActor.h>
#include <vtkProperty.h>

#include <QTimer>
#include <QMap>
#include <QObject>
#include <QSignalMapper>
#include <QThread>

class vtkQMLRenderWindowInteractor: public QObject, public vtkRenderWindowInteractor
{
    Q_OBJECT
public:

    static vtkQMLRenderWindowInteractor* New();
    vtkTypeMacro(vtkQMLRenderWindowInteractor,vtkRenderWindowInteractor)

    void mouseLeftPressed();
    void mouseLeftReleased();
    void mouseRightPressed();
    void mouseRightReleased();
    void mouseMiddlePressed();
    void mouseMiddleReleased();
    void mouseMoved(int x, int y);
    void mouseWheel(int angle);
    void keyPressed(int key);
    void keyReleased(int key);

    virtual void GetMousePosition(int *x, int *y) override;

    void setDefaultRenderer(vtkSmartPointer<vtkRenderer> renderer);

public slots:
    void vtkTimerEvent(int timerId);

signals:
    void pickedActorChanged(vtkActor* actor);

private:
    int shiftPressed = 0;
    int ctrlPressed = 0;
    int altPressed = 0;

    int mouseX = 0;
    int mouseY = 0;

    QMap<int, QTimer*> timers;
//    QMap<QTimer*, int> timer_ids;
    int timer_id_count = 1;
    QSignalMapper signalMapper;

    void invokeMouseEvent(int event);

protected:
    vtkQMLRenderWindowInteractor();
    ~vtkQMLRenderWindowInteractor();

    virtual int InternalCreateTimer(int timerId, int timerType, unsigned long duration) override;
    virtual int InternalDestroyTimer(int platformTimerId) override;

    vtkSmartPointer<vtkRenderer> defaultRenderer;
    void updatePickedActor();
    vtkActor* lastPickedActor = nullptr;

};

#endif // VTKQMLRENDERWINDOWINTERACTOR_H
