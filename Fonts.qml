import QtQuick 2.6
import QtQuick.Controls 2.1

Item {
    FontLoader {
        id: regularFont
        source: "fonts/RavensbourneSans-Regular.otf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('regularFont ready : name' + regularFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('regularFont error' );
            }
        }
    }
    FontLoader {
        id: boldFont
        source: "fonts/RavensbourneSans-Bold.otf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('boldFont ready : name' + boldFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('regularFont error' );
            }
        }
    }
    FontLoader {
        id: extraBoldFont
        source: "fonts/RavensbourneSans-ExtraBold.otf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('regularFont ready : name' + extraBoldFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('extraBoldFont error' );
            }
        }
    }
    property alias regularFont: regularFont
    property alias boldFont: boldFont
    property alias extraBoldFont: extraBoldFont
    property alias regular: regularFont.name
    property alias bold: boldFont.name
    property alias extraBold: extraBoldFont.name
}
