#include <QtGui/QGuiApplication>
#include <QtQml>
#include "qtquick2applicationviewer.h"
#include "ultimatetictactoemontecarloai.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<UltimateTicTacToeMontecarloAI>("UltimateTicTacToeAI", 1, 0, "Montecarlo");

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/ultimate-tictactoe/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
