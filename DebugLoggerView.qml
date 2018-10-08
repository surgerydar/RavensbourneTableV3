import QtQuick 2.0
import QtQuick.Controls 2.0

import "colours.js" as Colours

Rectangle {
    id: container
    color: Colours.white
    height: parent.height
    y: parent.height
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
    ListModel {
        id: messages
    }
    //
    //
    //
    ListView {
        id: messageView
        anchors.fill: parent
        model: messages
        spacing: 4
        delegate: Label {
            width: messageView.width
            padding: 8
            wrapMode: Label.WordWrap
            color: Colours.black
            text: model.text
            background: Rectangle {
                color: Colours.grey
            }
        }
    }
    //
    //
    //
    Connections {
        target: DebugLogger
        onNewMessage: {
            messages.append({text:message});
            messageView.positionViewAtEnd();
        }
    }

    //
    //
    //
    function open() {
        DebugLogger.activate();
        state = "open";
    }
    function close() {
        state = "closed";
        DebugLogger.deactivate();
        messages.clear();
    }
    function toggle() {
        if ( state == "closed" ) {
            open();
        } else {
            close();
        }
    }
}
