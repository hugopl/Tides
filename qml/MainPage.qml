import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    SelectionDialog {
        id: locationChooser
        titleText: qsTr("Location")
        model: ListModel {}
        onAccepted: tides.currentLocation = locationChooser.model.get(locationChooser.selectedIndex).name;
    }

    Image {
        id: emptyBg
        source: screen.currentOrientation === Screen.Landscape ? "image://theme/meegotouch-empty-application-background-black-landscape" : "image://theme/meegotouch-empty-application-background-black-portrait"
        anchors.fill: parent
        visible: tides.currentLocation.length === 0

        Label {
            text: qsTr("Tap on application header to choose a location")
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#525152"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 56
        }
    }

    Rectangle {
        id: viewHeader
        color: "#7490BA"
        width: parent.width
        height: screen.currentOrientation === Screen.Landscape ? UiConstants.HeaderDefaultHeightLandscape : UiConstants.HeaderDefaultHeightPortrait
        Text {
            text: tides.currentLocation ? tides.currentLocation : qsTr("Tides")
            elide: Text.ElideRight
            color: "white"
            font.pixelSize: 30
            anchors.fill: parent
            anchors.margins: UiConstants.DefaultMargin
            anchors.rightMargin: locationBtn.width + UiConstants.DefaultMargin
            verticalAlignment: Text.AlignVCenter
        }
        Image {
            id: locationBtn
            source: "image://theme/icon-m-textinput-combobox-arrow"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: UiConstants.DefaultMargin
        }
        MouseArea {
            anchors.fill: parent
            onClicked: locationChooser.open()
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


        ListView {
            id: tidesView
            clip: true
            anchors.margins: UiConstants.DefaultMargin
            anchors.top: viewHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right:  parent.right
            model: tides
            delegate: listDelegate
            section.property: "date"
            section.delegate: sectionHeading
        }
        ScrollDecorator { flickableItem: tidesView }

    Component.onCompleted: {
        // Workaround for a bug in SelectionDialog
        var i = 0;
        for(var l in locations) {
            locationChooser.model.append({name: locations[l]})
            if (locations[l] == tides.currentLocation)
                locationChooser.selectedIndex = i
                ++i
        }
    }

}
