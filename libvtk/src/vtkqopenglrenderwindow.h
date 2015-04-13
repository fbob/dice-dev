#ifndef VTKINTERNALOPENGLRENDERWINDOW_H
#define VTKINTERNALOPENGLRENDERWINDOW_H

#include <vtkGenericOpenGLRenderWindow.h>
#include <vtkObjectFactory.h>
#include <QOpenGLFunctions>

class QOpenGLFramebufferObject;
class vtkQFBORenderer;

class vtkQOpenGLRenderWindow : public vtkGenericOpenGLRenderWindow, protected QOpenGLFunctions
{
public:
  static vtkQOpenGLRenderWindow* New();
  vtkTypeMacro(vtkQOpenGLRenderWindow, vtkGenericOpenGLRenderWindow)

  void OpenGLInitState() override;
  void Render() override;
  void render();
  void setFBO(QOpenGLFramebufferObject *fbo);

  vtkQFBORenderer *fboRenderer;

protected:
  vtkQOpenGLRenderWindow();

  ~vtkQOpenGLRenderWindow();
};

#endif // VTKINTERNALOPENGLRENDERWINDOW_H
