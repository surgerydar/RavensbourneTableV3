import QtQuick 2.7
import QtQuick.Controls 2.1
import "colours.js" as Colours
Button {
    id: button
    width: radius * 2.
    height: radius * 2.
    //
    //
    //
    background: Rectangle {
        id: background
        width: button.height
        height: button.height
        radius: button.height / 2.
        color: button.checked ? Colours.red : Colours.yellow
    }
    //
    //
    //
    Image {
        id: iconImage
        anchors.fill: parent
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
        opacity: parent.enabled ? 1. : .5
    }
    //
    //
    //
    property real radius: 23
    property alias color: background.color
    property alias icon: iconImage.source
}
