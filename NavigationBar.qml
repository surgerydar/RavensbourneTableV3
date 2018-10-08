import QtQuick 2.0
import QtQuick.Controls 2.0

import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 62
    //
    //
    //
    ImageButton {
        id: rotateButton
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 8
        icon: "icons/rotate.png"
        onClicked: {
            rotate();
        }
    }
    //
    //
    //
    /*
    ImageButton {
        id: printButton
        anchors.right: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4
        icon: "icons/print-white.png"
        onClicked: {
            printDocument();
        }
    }
    */
    ImageButton {
        id: emailButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4
        icon: "icons/email-white.png"
        onClicked: {
            email();
        }
    }
    //
    //
    //
    /*
    TextField {
        id: searchText
        anchors.left: rotateButton.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: searchButton.left
        anchors.margins: 8
        height: 48
        color: Colours.black
        font.family: fonts.regular
        font.pointSize: 24
        background: Rectangle {
            id: background
            anchors.fill: parent
            radius: height / 2
            color: Colours.white
        }
        onFocusChanged: {
            searchFocus(focus);
        }
        Keys.onPressed: {
            console.log( 'TextField key pressed : ' + event.key );
        }
    }
    ImageButton {
        id: searchButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: backButton.left
        anchors.margins: 8
        enabled: searchText.text.length > 0
        icon: "icons/search.png"
        onClicked: {
            search(searchText.text);
        }
    }
    */
    //
    //
    //
    ImageButton {
        id: homeButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: backButton.left
        anchors.margins: 8
        icon: "icons/home-white.png"
        enabled: false
        onClicked: {
            goHome();
        }
    }
    ImageButton {
        id: backButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: forwardButton.left
        anchors.margins: 8
        icon: "icons/back_arrow-white.png"
        enabled: false
        onClicked: {
            goBack();
        }
    }
    ImageButton {
        id: forwardButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 8
        icon: "icons/forward_arrow-white.png"
        enabled: false
        onClicked: {
            goForward();
        }
    }
    //
    //
    //
    signal rotate()
    signal search( string term )
    signal goHome();
    signal goBack();
    signal goForward();
    signal printDocument();
    signal searchFocus( bool hasFocus );
    signal email();
    //
    //
    //
    property alias backEnabled: backButton.enabled
    property alias forwardEnabled: forwardButton.enabled
    property alias homeEnabled: homeButton.enabled
    property alias emailEnabled: emailButton.enabled
    //property alias printEnabled: printButton.enabled
}
