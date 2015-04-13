#ifndef FBORENDERER_H
#define FBORENDERER_H

#include <QtQuick/QQuickFramebufferObject>

class vtkQOpenGLRenderWindow;
class vtkQFBORenderer;
class vtkGenericOpenGLRenderWindow;

#define vtkRenderingCore_AUTOINIT 4(vtkInteractionStyle,vtkRenderingFreeType,vtkRenderingFreeTypeOpenGL,vtkRenderingOpenGL)
#define vtkRenderingVolume_AUTOINIT 1(vtkRenderingVolumeOpenGL)

class FBORenderItem : public QQuickFramebufferObject
{
    Q_OBJECT
    friend class vtkQFBORenderer;

    Q_PROPERTY(bool loading READ getLoading WRITE setLoading NOTIFY loadingChanged)

    Q_PROPERTY(QVariantList visObjects READ visObjects WRITE setVisObjects NOTIFY visObjectsChanged)

    Q_PROPERTY(QVariant app READ app WRITE setApp NOTIFY appChanged)

public:
    FBORenderItem(QQuickItem* parent=0);
    ~FBORenderItem();
    Renderer *createRenderer() const;

    Q_INVOKABLE void deleteLater();

    bool getLoading() const;

    QVariantList visObjects() const;

    QVariant app() const;

public slots:
    void setLoading(bool arg);

    void setVisObjects(QVariantList arg);

    void setApp(QVariant arg);

signals:
    void mousePressed(int buttons);
    void mouseReleased(int buttons);
    void mouseMoved(int x, int y);
    void mouseWheel(int angle);
    void mouseClicked(int buttons, int x, int y);
    void keyPressed(int key);

    void reload();

    void loadingChanged(bool arg);

    void visObjectsChanged(QVariantList arg);

    void appChanged(QVariant arg);

protected:
    vtkQOpenGLRenderWindow *renderWindow;

private:
    bool loading = false;
    QVariantList m_visObjects;
    QVariant m_app;
};

#endif // FBORENDERER_H
