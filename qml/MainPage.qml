import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    Rectangle {
        id: viewHeader
        color: "#7490BA"
        width: parent.width
        height: screen.currentOrientation == Screen.Landscape ? UiConstants.HeaderDefaultHeightLandscape : UiConstants.HeaderDefaultHeightPortrait
        Text {
            text: tides.currentLocation ? tides.currentLocation : qsTr("Tides")
            elide: Text.ElideRight
            color: "white"
            font.pixelSize: 30
            anchors.fill: parent
            anchors.margins: UiConstants.DefaultMargin
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }
    }

    Component {
        id: sectionHeading
        Item {
            width: tidesView.width
            height: childrenRect.height

            Text {
                id: sectionText
                text: section
                font.bold: true
                font.pixelSize: 30
                color: "white"
            }
            Image {
                source: "image://theme/meegotouch-separator-inverted-background-horizontal"
                height: 2
                anchors.left: sectionText.right
                anchors.right: parent.right
                anchors.verticalCenter: sectionText.verticalCenter
                anchors.leftMargin: 10
            }
        }
    }

    Component {
        id: listDelegate
        Rectangle {
            width: tidesView.width
            height: 34
            color: index % 2 ? "#363434" : "transparent"
            Text {
                anchors.fill: parent
                anchors.rightMargin: 10
                horizontalAlignment: "AlignRight"
                color: "white"
                font.pixelSize: 30
                text: time + "        " + tide
            }
        }
    }

    Item {
        anchors.margins: UiConstants.DefaultMargin
        anchors.top: viewHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right:  parent.right

        ListView {
            id: tidesView
            clip: true
            anchors.fill: parent
            width: parent.width
            model: tides
            delegate: listDelegate
            section.property: "date"
            section.delegate: sectionHeading
        }
    }
}
