import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import SodaControls 1.0

import "colours.js" as Colours

ApplicationWindow {
    id: appWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Ravensbourne SmartTable")
    //
    //
    //
    Fonts {
        id: fonts
    }
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.orange
    }
    Rectangle {
        width: 2
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: Colours.yellow
    }
    //
    //
    //
    Browser {
        id: leftBrowser
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        onCalibrationChanged: {
            if ( calibration ) {
                rightBrowser.calibration = false;
            }
        }
        onScannerPortChanged: {
            if ( scannerPort.length > 0 ) {
                updateSettings();
            }
        }
    }
    Browser {
        id: rightBrowser
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        rotation: 180
        onCalibrationChanged: {
            if ( calibration ) {
                leftBrowser.calibration = false;
            }
        }
        onScannerPortChanged: {
            if ( scannerPort.length > 0 ) {
                updateSettings();
            }
        }
    }
    //
    //
    //
    TimeoutDialog {
        id: timeoutDialog
    }
    //
    //
    //
    DebugLoggerView {
        id: debugView
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
    }
    //
    //
    //
    Timer {
        id: startupTimer
        interval: 30 * 1000
        repeat: false
        onTriggered: {
            console.log('loading settings');
            //
            // load settingns
            //
            var settings = JSONFile.read("settings.json") || {};
            console.log( "before: " + JSON.stringify(settings) );
            settings.leftscanner = settings.leftscanner || "";
            settings.rightscanner = settings.rightscanner || "";
            settings.baseurl = settings.baseurl || "https://www.materialconnexion.online";
            settings.databaseurl = settings.databaseurl || "https://www.materialconnexion.online/database";
            settings.searchtemplate = settings.searchtemplate || "https://www.materialconnexion.online/database/catalogsearch/result/?q=<term>";
            settings.materialtemplate = settings.materialtemplate || "https://www.materialconnexion.online/database/<code>.html";
            settings.timeout = settings.timeout || Timeout.getTimeout() / 1000;
            settings.emailSubject = settings.emailSubject || "Materials from Ravensbourne Table";
            settings.emailPrefix = settings.emailPrefix || "<h1>Materials from Ravensbourne Table</h1>";
            settings.emailPostfix = settings.emailPostfix || "";
            settings.emailAddress = settings.emailAddress || "ravensbournetable@gmail.com";
            settings.emailHost = settings.emailHost || "smtp.gmail.com";
            settings.emailPort = settings.emailPort || 465;
            settings.emailUsername = settings.emailUsername || "ravensbournetable@gmail.com";
            settings.emailPassword = settings.emailPassword || "Ta8le202";
            console.log( "after: " + JSON.stringify(settings) );
            JSONFile.write("settings.json",settings);
            //
            // restore settings
            //
            blockUpdate = true;
            leftBrowser.scannerPort = settings.leftscanner;
            rightBrowser.scannerPort = settings.rightscanner;
            baseUrl = settings.baseurl;
            databaseUrl = settings.databaseurl;
            searchTemplate = settings.searchtemplate;
            materialTemplate = settings.materialtemplate;
            Timeout.setTimeout(settings.timeout*1000);
            emailSubject = settings.emailSubject;
            emailPrefix = settings.emailPrefix;
            emailPostfix = settings.emailPostfix;
            emailAddress = settings.emailAddress;
            emailHost = settings.emailHost;
            emailPort = settings.emailPort;
            emailUsername = settings.emailUsername;
            emailPassword = settings.emailPassword;
            blockUpdate = false;
            //
            //
            //
            leftBrowser.goHome(true);
            rightBrowser.goHome(true);
            //
            //
            //
            BarcodeScanner.connect();
            //
            //
            //
            appWindow.contentItem.enabled = true;
        }
    }

    //
    //
    //
    Component.onCompleted: {
        //
        // go fullscreen
        //
        appWindow.contentItem.enabled = false;
        appWindow.showFullScreen();
        WindowControl.setAlwaysOnTop(true);
        //
        //
        //
        startupTimer.start();
    }
    //
    //
    //
    function updateSettings() {
        if ( blockUpdate ) return;
        var settings = {
            leftscanner: leftBrowser.scannerPort,
            rightscanner: rightBrowser.scannerPort,
            baseurl: baseUrl,
            searchtemplate: searchTemplate,
            materaltemplate: materialTemplate,
            timeout: Timeout.getTimeout() / 1000,
            emailSubject: emailSubject,
            emailPrefix: emailPrefix,
            emailPostfix: emailPostfix,
            emailAddress: emailAddress,
            emailHost: emailHost,
            emailPort: emailPort,
            emailUsername: emailUsername,
            emailPassword: emailPassword
        };
        JSONFile.write("settings.json",settings);
    }
    //
    //
    //
    Connections {
        target: Timeout
        onTimeout: {
            console.log('Timeout.onTimeout')
            timeoutDialog.show( function() {
                                leftBrowser.goHome(true);
                                rightBrowser.goHome(true);
                            });
        }
    }
    Shortcut {
        sequence: "Ctrl+T"
        onActivated: BarcodeScanner.test();
    }
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: debugView.toggle();
    }
    //
    //
    //
    property bool blockUpdate: true
    property string baseUrl: "https://www.materialconnexion.online"
    property string databaseUrl: "https://www.materialconnexion.online/database"
    property string searchTemplate: "https://www.materialconnexion.online/database/catalogsearch/result/?q=<term>"
    property string materialTemplate: "https://www.materialconnexion.online/database/<code>.html"
    property string emailSubject: "Materials from Ravensbourne Table"
    property string emailPrefix: ""
    property string emailPostfix: ""
    property string emailAddress: "ravensbournetable@gmail.com"
    property string emailHost: "smtp.gmail.com"
    property int emailPort: 465
    property string emailUsername: "ravensbournetable@gmail.com"
    property string emailPassword: "Ta8le202"
}
