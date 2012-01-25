# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Add dependency to symbian components
# CONFIG += qtquickcomponents

QT += declarative sql

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    tidesmodel.cpp

OTHER_FILES += \
    qml/main.qml \
    qml/MainPage.qml \
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

TRANSLATIONS += i18n/tides.pt.ts
CODECFORTR = UTF-8

isEmpty(QMAKE_LRELEASE) {
    QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}

isEmpty(TS_DIR):TS_DIR = i18n

TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$TS_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM
PRE_TARGETDEPS += compiler_TSQM_make_all

# Install procedures
installPrefix = /opt/Tides

desktopfile.files = Tides_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = Tides80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
db.files = tides.sqlite3
db.path = /opt/Tides
INSTALLS += icon desktopfile db

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/Tides/bin
    INSTALLS += target
}
