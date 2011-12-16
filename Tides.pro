# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Add dependency to symbian components
# CONFIG += qtquickcomponents

QT += declarative

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    tidesmodel.cpp

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

HEADERS += \
    tidesmodel.h

RESOURCES += \
    tides.qrc

# Install procedures
installPrefix = /opt/Tides

desktopfile.files = Tides_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = Tides80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
INSTALLS += icon desktopfile
contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/Tides/bin
    INSTALLS += target
}
