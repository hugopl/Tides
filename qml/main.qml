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
                text: qsTr("<center style=\"padding-bottom: 10px;\"><img src=\":/icon.png\" width=\"64\" height=\"64\"><p><b>Tides v" + TIDES_VERSION + "</b><br>&copy; 2011 Hugo Parente Lima<br><a href=\"https://github.com/hugopl/Tides\">https://github.com/hugopl/Tides</a></p></center>")
                anchors.bottomMargin: 10
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        buttons: ButtonRow {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        text: qsTr("OK")
                        onClicked: aboutBox.accept()
                    }
                }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")
                onClicked: aboutBox.open()
            }
        }
    }

    Component.onCompleted: {
        theme.inverted = true
    }
}
