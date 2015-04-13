#include "fborenderitem.h"

#include <QOpenGLFunctions>
#include <QDebug>
#include <QQuickWindow>

#include "vtkqfborenderer.h"
#include "vtkqopenglrenderwindow.h"

FBORenderItem::FBORenderItem(QQuickItem* parent): QQuickFramebufferObject(parent)
{
    renderWindow = vtkQOpenGLRenderWindow::New();
}

FBORenderItem::~FBORenderItem()
{
    qDebug() << "delete FBORenderItem";
    if (renderWindow)
        renderWindow->Delete();
}

QQuickFramebufferObject::Renderer *FBORenderItem::createRenderer() const
{
    return new vtkQFBORenderer(renderWindow);
}

void FBORenderItem::deleteLater()
{
    QQuickFramebufferObject::deleteLater();
}

bool FBORenderItem::getLoading() const
{
    return loading;
}

QVariantList FBORenderItem::visObjects() const
{
    return m_visObjects;
}

QVariant FBORenderItem::app() const
{
    return m_app;
}

void FBORenderItem::setLoading(bool arg)
{
    if (loading == arg)
        return;

    loading = arg;
    emit loadingChanged(arg);
}

void FBORenderItem::setVisObjects(QVariantList arg)
{
    if (m_visObjects == arg)
        return;

    m_visObjects = arg;
    emit visObjectsChanged(arg);
}

void FBORenderItem::setApp(QVariant arg)
{
    if (m_app == arg)
        return;

    m_app = arg;
    emit appChanged(arg);
}
