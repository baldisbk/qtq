TEMPLATE = app

QT += qml quick widgets

TARGET = TimeManager

SOURCES += main.cpp \
    timemodel.cpp \
    timecalendar.cpp \
    timestatmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    timemodel.h \
    timecalendar.h \
    timestatmodel.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
