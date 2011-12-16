#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include "tidesmodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    TidesModel model;

    QDeclarativeView viewer;
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.rootContext()->setContextProperty("TIDES_VERSION", "1.0.0");
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
