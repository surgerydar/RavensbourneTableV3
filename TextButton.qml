import QtQuick 2.7
import "colours.js" as Colours

Rectangle {
    width: Math.max( 48, label.contentWidth + height / 2 )
    height: 48
    radius: height / 2
    color: Colours.grey
    opacity: enabled ? 1. : .5
    //
    //
    //
    Text {
        id: label
        anchors.fill: parent
        font.family: fonts.bold
        font.pixelSize: 24
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Colours.black
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked();
        }
    }
    //
    //
    //
    signal clicked()
    //
    //
    //
    property alias text: label.text
}
