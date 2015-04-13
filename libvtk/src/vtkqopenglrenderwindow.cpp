#include "vtkqopenglrenderwindow.h"

#include "vtkqfborenderer.h"
#include <QOpenGLFramebufferObject>

vtkStandardNewMacro(vtkQOpenGLRenderWindow)

void vtkQOpenGLRenderWindow::OpenGLInitState()
{
    vtkGenericOpenGLRenderWindow::OpenGLInitState();

    this->MakeCurrent();
    initializeOpenGLFunctions();

    glUseProgram(0);

    // enable z-buffer testing
    glDepthMask(GL_TRUE);
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // enable transparency effects
    glEnable(GL_BLEND);
}

void vtkQOpenGLRenderWindow::Render()
{
    if (this->fboRenderer)
    {
        this->fboRenderer->needUpdate();
    }
}

void vtkQOpenGLRenderWindow::render()
{
    vtkGenericOpenGLRenderWindow::Render();
}

void vtkQOpenGLRenderWindow::setFBO(QOpenGLFramebufferObject *fbo)
{
    this->BackLeftBuffer = this->FrontLeftBuffer = this->BackBuffer = this->FrontBuffer = static_cast<unsigned int>(GL_COLOR_ATTACHMENT0);

    QSize fboSize = fbo->size();
    this->Size[0] = fboSize.width();
    this->Size[1] = fboSize.height();
    this->NumberOfFrameBuffers = 1;
    this->FrameBufferObject       = static_cast<unsigned int>(fbo->handle());
    this->DepthRenderBufferObject = 0;
    this->TextureObjects[0]       = static_cast<unsigned int>(fbo->texture());
    this->OffScreenRendering = 1;
    this->OffScreenUseFrameBuffer = 1;
    this->Modified();
}

vtkQOpenGLRenderWindow::vtkQOpenGLRenderWindow(): fboRenderer(nullptr)
{
}

vtkQOpenGLRenderWindow::~vtkQOpenGLRenderWindow()
{
    this->OffScreenRendering = 0;
}
