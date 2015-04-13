#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QIcon>
#include <QLocale>
#include <QtWebEngine>
#include <QDebug>

#include "pythonloader.h"

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.addImportPath("libview");

    // We must set the locale always to C as some tools won't work correctly without it.
    // e.g. decimal points will always be "." this way.
    QLocale::setDefault(QLocale::c());

    PythonLoader pythonLoader{&app};
    QObject* dice = pythonLoader.getObject("core.main", "Dice");
    if (!dice) {
        qDebug() << "Could not initialize the python core!";
        return -1;
    }

    QtWebEngine::initialize();
    QQmlContext* context = engine.rootContext();

    QVariant vEngine, vContext;
    vEngine.setValue(&engine);
    vContext.setValue(context);
    dice->setProperty("qmlEngine", vEngine);
    dice->setProperty("qmlContext", vContext);

    context->setContextProperty("dice", dice);
    engine.load(QUrl("libview/Window/main.qml"));
    app.topLevelWindows().first()->setIcon(QIcon("libview/Window/images/dice_logo_grey.svg"));
    return app.exec();
}
