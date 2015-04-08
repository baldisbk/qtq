#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "timemodel.h"
#include "timecalendar.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<TimeModel>("TimeModel", 1, 0, "TimeModel");
    qmlRegisterType<TimeCalendar>("TimeModel", 1, 0, "TimeCalendar");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
