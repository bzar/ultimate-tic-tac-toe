#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml>
#include "ultimatetictactoemontecarloai.h"
#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    QGuiApplication* app = SailfishApp::application(argc, argv);
    QQuickView* view = SailfishApp::createView();

    qmlRegisterType<UltimateTicTacToeMontecarloAI>("UltimateTicTacToeAI", 1, 0, "Montecarlo");
    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->show();
    return app->exec();
}
