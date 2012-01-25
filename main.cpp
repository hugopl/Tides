#include <MDeclarativeCache>
#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QLocale>
#include <QScopedPointer>
#include <QTranslator>
#include "tidesmodel.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
    app->setApplicationName("Tides");
    app->setOrganizationName("Tides");
    TidesModel model;

    // install translator
    QTranslator translator;
    if (translator.load("tides." + QLocale::system().name(), ":/"))
        app->installTranslator(&translator);

    QDeclarativeView viewer;
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.rootContext()->setContextProperty("locations", QVariant::fromValue(model.locations()));
    viewer.rootContext()->setContextProperty("TIDES_VERSION", "1.0.1");
    viewer.rootContext()->setContextProperty("tides", &model);
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.showFullScreen();
    return app->exec();
}
