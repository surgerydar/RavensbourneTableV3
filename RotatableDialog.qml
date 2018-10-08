import QtQuick 2.0

import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        radius: width / 2
        color: Colours.yellow
    }
    //
    //
    //
    ImageButton {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 8
        //
        //
        //
        icon: "icons/rotate-white.png"
        color: "transparent"
        onClicked: {
            container.rotation = container.rotation === 0. ? 180. : 0.;
        }
    }
    //
    //
    //
    Behavior on rotation {
        NumberAnimation {
            duration: 500
        }
    }
    //
    //
    //
    property alias colour: background.color
}
