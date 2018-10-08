import QtQuick 2.0
import QtQuick.Controls 2.0

import "colours.js" as Colours
import "inputhook.js" as InputHook

Rectangle {
    id: container
    color: Colours.black
    y: parent.height
    height: keyboard.y + keyboard.childrenRect.height + 8
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                y: container.parent.height
                opacity: 0.
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                y: container.parent.height - container.height
                opacity: 1.
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    ImageButton {
        id: closeButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        icon: "icons/down_arrow-white.png"
        color: "transparent"
        onClicked: {
            close();
        }
    }
    ImageButton {
        id: actionButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        visible: actionCallback !== undefined && actionCallback !== null
        icon: "icons/back_arrow-white.png"
        color: "transparent"
        onClicked: {
            if ( actionCallback ) {
                actionCallback( targetId );
            }
            close();
        }
    }
    //
    //
    //
    Column {
        id: keyboard
        anchors.top: closeButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 8
        spacing: 8
        Repeater {
            model: keys.length
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8
                Repeater {
                    model: keys[index].length
                    Button {
                        width: 46
                        text: row[ index ]
                        onClicked: {
                            if ( updateCallback ) {
                                if ( row[ index ] === 'del' ) {
                                    targetValue = targetValue.substring(0,targetValue.length-1);
                                } else {
                                    targetValue += row[ index ];
                                }
                                updateCallback( targetId, targetValue );
                            } else {
                                console.log( 'no update' );
                            }
                        }
                    }
                }
                property var row: keys[index]
            }
        }
        Button {
            width: parent.width / 4
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if ( updateCallback ) {
                    targetValue += ' ';
                    updateCallback( targetId, targetValue );
                } else {
                    console.log( 'no update' );
                }
            }
        }
    }
    //
    //
    //
    function edit( _targetId, _targetValue, _update, _action ) {
        console.log( 'editing : ' + _targetId + ' : ' + _targetValue + ' : ' + _update + ' : ' + _action );
        targetId = _targetId;
        targetValue = _targetValue;
        updateCallback = _update;
        actionCallback = _action;
        state = "open";
    }
    function close() {
        state = "close";
        targetId = "";
        targetValue = "";
        updateCallback = null;
        actionCallback = null;
    }
    //
    //
    //
    property var keys: InputHook.keys
    property string targetId: ""
    property string targetValue: ""
    property var updateCallback: null
    property var actionCallback: null

}
