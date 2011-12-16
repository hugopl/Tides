import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Dialog {
        id: aboutBox
        title: qsTr("About")
        content: Item {
            width: parent.width
            height: 170
            Text {
                anchors.centerIn: parent
                font.pixelSize: 22
                color: "white"
                text: qsTr("<center style=\"padding-bottom: 10px;\"><img src=\":/icon.png\" width=\"64\" height=\"64\"><p><b>Tides v" + TIDES_VERSION + "</b><br>&copy; 2011 Hugo Parente Lima</p></center>")
                anchors.bottomMargin: 10
            }
        }
        buttons: Button {
            text: qsTr("OK")
            onClicked: aboutBox.accept()
        }
    }

    SelectionDialog {
        id: locationChooser
        titleText: qsTr("Location")
        model: ListModel {}
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Change location")
                onClicked: locationChooser.open();
            }
            MenuItem {
                text: qsTr("About")
                onClicked: aboutBox.open()
            }
        }
    }

    Component.onCompleted: {
        theme.inverted = true
        // Workaround for a bug in SelectionDialog
        for(var l in locations)
            locationChooser.model.append({name: locations[l]})
    }
}
