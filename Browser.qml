import QtQuick 2.7
import QtQuick.Controls 2.1
import QtWebEngine 1.4
//import QtQuick.VirtualKeyboard 2.0

import SodaControls 1.0

import "colours.js" as Colours
import "inputhook.js" as InputHook

Item {
    id: container
    //
    //
    //
    ListModel {
        id: materialHistory
    }
    //
    //
    //
    ImageButton {
        id: rotateButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        icon: "icons/rotate.png"
        onClicked: {
            container.rotation = container.rotation === 0 ? 180 : 0
        }
    }
    //
    //
    //
    WebEngineView {
        id: webBrowser
        anchors.top: rotateButton.bottom
        anchors.left: parent.left
        anchors.bottom: navigationBar.top
        anchors.right: parent.right
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        backgroundColor: "transparent"
        /*
        onNewViewRequested: {
            request.openIn(webBrowser);
        }
        */
        onNavigationRequested: {
            var url = request.url.toString();
            console.log( 'Browser.webBrowser.onNavigationRequested : ' + url );
            if ( !url.startsWith( baseUrl ) ) {
                // TODO: inform user this is not allowed
                request.action = WebEngineNavigationRequest.IgnoreRequest;
            } else {
                request.action = WebEngineNavigationRequest.AcceptRequest;
            }
        }
        onContextMenuRequested: {
            request.accepted = true;
        }

        onLoadingChanged: {
            console.log( 'url : ' + loadRequest.url );
            switch( loadRequest.status ) {
            case WebEngineView.LoadStartedStatus :
                console.log( 'navigation started' );
                busyIndicator.visible = true;
                loaded = false;
                break;
            case WebEngineView.LoadStoppedStatus :
                console.log( 'navigation stopped : error=' +  loadRequest.errorString + ' code=' + loadRequest.errorCode );
                busyIndicator.visible = false;
                break;
            case WebEngineView.LoadFailedStatus :
                // TODO: inform user of error
                console.log( 'navigation failed : error=' +  loadRequest.errorString + ' code=' + loadRequest.errorCode );
                busyIndicator.visible = false;
                break;
            case WebEngineView.LoadSucceededStatus :
                console.log( 'navigation success' );
                busyIndicator.visible = false;
                loaded = true;
                runJavaScript(InputHook.hook(baseUrl), function(result) {
                    console.log( 'InputHook.hook() : ' + result );
                });
                //
                //
                //
                var prefixSuffix = materialTemplate.split('<code>');
                var url = loadRequest.url.toString();
                if ( url.startsWith( prefixSuffix[ 0 ] ) && url.endsWith( prefixSuffix[ 1 ] ) ) {
                    //
                    //
                    //
                    console.log( 'adding ' + title + ' to history' );
                    var count = materialHistory.count;
                    for ( var i = 0; i < count; i++ ) {
                        var material = materialHistory.get(i);
                        if ( material.url === url ) return;
                    }
                    materialHistory.append({title:title,url:url,share:true});
                }
            }
        }

        onAuthenticationDialogRequested: {
            console.log( 'onAuthenticationDialogRequested' );
        }

        onCertificateError: {
            console.log( 'onCertificateError : ' + error.error + ' : ' + error.description );
            error.ignoreCertificateError();
        }

        onJavaScriptConsoleMessage: {
            console.log( 'onJavaScriptConsoleMessage : ' + message + ' : line : ' + lineNumber + ' : source : ' + sourceID );
            var command = message.split('|');
            if ( command.length > 1 ) {
                switch( command[ 0 ] ) {
                case 'edit' :
                    console.log( 'editing field : ' + command[ 1 ] + ' : existing content : ' + command[ 2 ] );
                    keyboard.edit(command[ 1 ],command[ 2 ],
                                  function( targetId, value ) {
                                      console.log( 'InputHook.update(' + targetId + ',' + value + ')' );
                                      runJavaScript(InputHook.update( targetId, value ), function(result) {
                                          console.log( result );
                                      });
                                  },
                                  function( targetId ) {
                                      console.log('InputHook.action(' + targetId + ')' );
                                      runJavaScript(InputHook.action( targetId ), function(result) {
                                          console.log(  result );
                                      });
                                  });
                    break;
                case 'print' :
                    var source = command.splice(0,1).join();
                    console.log('printing : ' + source);
                    if ( source && source.length > 0 )
                        DocumentPrinter.printHtml(url,source);
                    break;
                }
            }
        }
        property bool loaded: false
    }
    //
    //
    //
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: webBrowser
        running: visible
        visible: false    
        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64

                RotationAnimator {
                    target: item
                    running: busyIndicator.visible && busyIndicator.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: Colours.yellow
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
    }
    //
    //
    //
    NavigationBar {
        id: navigationBar
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //anchors.bottomMargin: 16
        forwardEnabled: webBrowser.canGoForward
        backEnabled: webBrowser.canGoBack
        homeEnabled: webBrowser.url && webBrowser.url.toString() !== databaseUrl
        emailEnabled: materialHistory.count > 0
        //printEnabled: webBrowser.loaded
        onRotate: {
           container.rotation = container.rotation === 0 ? 180 : 0
        }
        onSearch: {
            // TODO: export search url template to settings
            webBrowser.url = searchTemplate.replace('<term>', term);
        }
        onGoBack: {
            webBrowser.goBack();
        }
        onGoHome: {
            container.goHome();
        }
        onGoForward: {
            webBrowser.goForward();
        }
        onSearchFocus: {
            inputPanel.active = hasFocus;
        }
        onPrintDocument: {
            busyIndicator.visible = true;
            navigationBar.enabled = false;
            var filepath = SystemUtils.mediaPath( 'print' + Date.now() + '.pdf' );
            webBrowser.printToPdf(filepath);
            printTimer.waitForFile(filepath);
            /*
            if ( pdfPrinter.load(filepath) ) {
                pdfPrinter.print();
                SystemUtils.removeFile(filepath);
            } else {
                console.log( 'Unable to load file : ' + filepath );
            }
            */
        }
        onEmail: {
            //emailSender.send("jons@soda.co.uk","TableTest","Well hellooo!" );
            emailDialog.show(materialHistory);
        }
    }
    //
    //
    //
    EmailDialog {
        id: emailDialog
    }

    //
    //
    //
    Timer {
        id: printTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if ( !( path.length === 0 || SystemUtils.fileExists(path) ) ) {
                attempts++;
                if ( attempts > 60 ) {
                    busyIndicator.visible = false;
                    navigationBar.enabled = true;
                } else {
                    restart();
                }
            } else {
                Qt.callLater( function(filepath) {
                    console.log( 'Browser : loading file for printing : ' + filepath );
                    if ( pdfPrinter.load(filepath) ) {
                        console.log( 'Browser : printing file : ' + filepath );
                        pdfPrinter.print();
                    } else {
                        console.log( 'Browser : unable to load file : ' + filepath );
                    }
                    console.log( 'Browser : removing file : ' + filepath );
                    SystemUtils.removeFile(filepath);
                    busyIndicator.visible = false;
                    navigationBar.enabled = true;
                }, path );
            }
        }
        function waitForFile( filepath ) {
            path = filepath;
            attempts = 0;
            start();
        }
        property string path: ""
        property int attempts: 0
    }
    //
    //
    //
    PDFDocument {
        id: pdfPrinter

    }

    //
    //
    //
    SoftKeyboard {
        id: keyboard
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
    }
    //
    //
    //
    ImageButton {
        id: calibrationButton
        anchors.centerIn: webBrowser
        visible: scannerPort.length === 0
        checkable: true
        icon: container.x === 0 ? container.rotation === 0 ? "icons/back_arrow-white.png" : "icons/forward_arrow-white.png" : container.rotation === 0 ? "icons/forward_arrow-white.png" : "icons/back_arrow-white.png"
    }
    Rectangle {
        anchors.fill: callibrationLabel
        anchors.margins: -4
        visible: scannerPort.length === 0 && calibrationButton.checked
        radius: 4
        color: Colours.red
    }
    Label {
        id: callibrationLabel
        anchors.top: calibrationButton.bottom
        anchors.horizontalCenter: calibrationButton.horizontalCenter
        anchors.margins: 8
        visible: scannerPort.length === 0 && calibrationButton.checked
        font.family: fonts.regular
        font.pointSize: 24
        horizontalAlignment: Label.AlignHCenter
        color: Colours.black
        text: "scan barcode"
    }
    //
    //
    //
    EmailSender {
        id: emailSender
        //
        //
        //
        email: emailAddress
        host: emailHost
        port: emailPort
        username: emailUsername
        password: emailPassword
        //
        //
        //
        onStatus: {
        }
        onError: {
            busyIndicator.visible = false;
        }
        onDone: {
            busyIndicator.visible = false;
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
    Component.onCompleted: {
        //webBrowser.url = databaseUrl;
    }
    //
    //
    //
    Connections {
        target: BarcodeScanner
        onNewCode : {// (QString portname, QString barcode);
            if ( calibrationButton.checked ) {
                calibrationButton.checked = false;
                scannerPort = portname;
            }
            if ( scannerPort === portname ) webBrowser.url = buildMaterialUrl(barcode);
        }
    }
    //
    //
    //
    function buildMaterialUrl( barcode ) {
        if ( barcode.indexOf('library.materialconnexion.com') >= 0 ) { // version 1
            // library.materialconnexion.com/ProductPage.aspx?mc=697702
            var productCodeIndex = barcode.lastIndexOf('mc=');
            if ( productCodeIndex >= 0 ) {
                var code = barcode.substring(productCodeIndex+3);
                return materialTemplate.replace('<code>', code );
            } else {
                console.log( 'Browser.show : rejecting barcode : ' + barcode);
            }
        } else { // assume current version
            var productPage = barcode.substring(barcode.lastIndexOf('/'));
            return databaseUrl + productPage;
        }

        return "";
    }
    function goHome(clearHistory) {
        webBrowser.url = databaseUrl;
        if ( clearHistory ) {
            materialHistory.clear();
        }
    }
    //
    //
    //
    property string scannerPort: ""
    property alias calibration: calibrationButton.checked
}
