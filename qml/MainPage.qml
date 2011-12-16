import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait
    anchors.fill: parent

    ListModel {
        id: tidesModel
        ListElement {
            date: "18/03/2012"
            time: "01:53"
            tide: "2.2"
        }
        ListElement {
            date: "18/03/2012"
            time: "07:56"
            tide: "0.7"
        }
        ListElement {
            date: "18/03/2012"
            time: "14:04"
            tide: "2.4"
        }
        ListElement {
            date: "18/03/2012"
            time: "20:24"
            tide: "0.5"
        }

        ListElement {
            date: "19/03/2012"
            time: "02:41"
            tide: "2.4"
        }
        ListElement {
            date: "19/03/2012"
            time: "08:45"
            tide: "0.6"
        }
        ListElement {
            date: "19/03/2012"
            time: "14:53"
            tide: "1.1"
        }
    }

    Rectangle {
        id: viewHeader
        color: "steelBlue"
        width: parent.width
        height: screen.currentOrientation == Screen.Landscape ? UiConstants.HeaderDefaultHeightLandscape : UiConstants.HeaderDefaultHeightPortrait
        Text {
            text: qsTr("Tides")
            color: "white"
            font.pixelSize: 30
            anchors.centerIn: parent
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
            model: tidesModel
            delegate: Text { horizontalAlignment: "AlignRight"; width: tidesView.width; color: "white"; font.pixelSize: 30; text: time + "        " + tide}
            section.property: "date"
            section.delegate: sectionHeading
        }
    }
}
