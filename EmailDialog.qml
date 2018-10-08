import QtQuick 2.0
import QtQuick.Controls 2.0

import "colours.js" as Colours

RotatableDialog {
    id: container
    //
    // geometry
    //
    height: parent.height - ( keyboard.height + 32 )
    width: height
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: keyboard.top
    anchors.bottomMargin: 34
    visible: false
    opacity: 1.0
    colour: Colours.yellow
    //
    //
    //
    Column {
        spacing: 8
        anchors.centerIn: parent
        //
        //
        //
        TextField {
            id: email
            width: materialList.width
            height: 48
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: TextField.AlignVCenter
            placeholderText: "email"
            font.family: fonts.regular
            font.pixelSize: 24
            color: Colours.black
            validator: RegExpValidator {
                regExp: /^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
            }
            background: Rectangle {
                radius: height / 2
                color: Colours.white
                border.color: "transparent"
            }
            onFocusChanged: {
                if ( focus ) {
                    keyboard.edit('email',text,
                                  function( targetId, value ) {
                                      if ( targetId === 'email' ) {
                                          text = value;
                                      }
                                  },
                                  function( targetId ) {
                                      if ( acceptableInput ) {
                                          send();
                                          hide();
                                      }
                                  }
                        );
                }
            }
        }
        //
        //
        //
        ListView {
            id: materialList
            anchors.horizontalCenter: parent.horizontalCenter
            height: container.height * .3
            width: container.width * .5
            clip: true
            model: ListModel {}
            delegate: Rectangle {
                width: materialList.width
                height: 46
                color: Colours.white
                Label {
                    anchors.left: parent.left
                    anchors.right: include.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8
                    horizontalAlignment: Label.AlignLeft
                    verticalAlignment: Label.AlignVCenter
                    fontSizeMode: Label.HorizontalFit
                    elide: Label.ElideRight
                    font.family: fonts.regular
                    font.pointSize: 24
                    color: Colours.black
                    text: model.title
                }
                CheckBox {
                    id: include
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8
                    checked: model.share
                    onCheckedChanged: {
                        materialList.model.set(index,{share:checked});
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            TextButton {
                anchors.verticalCenter: parent.verticalCenter
                text: 'Cancel'
                onClicked: {
                    hide();
                }
            }
            TextButton {
                anchors.verticalCenter: parent.verticalCenter
                text: 'Send'
                enabled: email.acceptableInput
                onClicked: {
                    send();
                    hide();
                }
            }
        }
    }
    //
    //
    //
    function send() {
        var links = [];
        var count = materialList.model.count;
        for ( var i = 0; i < count; i++ ) {
            var material = materialList.model.get(i);
            if ( material.share ) {
                links.push( '<a href="'+ material.url + '">' +  material.title + '</a>' );
            }
        }
        if ( links.length > 0 ) {
            var message = emailPrefix;
            links.forEach(function(link) {
                message += link + '<br/>';
            });
            message += emailPostfix;
            busyIndicator.visible= true;
            emailSender.send(email.text,emailSubject,message);
        }
    }
    //
    //
    //
    function show( materials ) {
        materialList.model.clear();
        var count = materials.count;
        for ( var i = 0; i < count; i++ ) {
            materialList.model.append(materials.get(i));
        }
        visible = true;
    }
    function hide() {
        visible = false;
        materialList.model.clear();
        email.text = "";
    }
}
