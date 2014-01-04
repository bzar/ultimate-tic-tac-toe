import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
  id: button

  width: 256
  height: 64

  signal clicked

  property color color: "#fff"
  property int borderWidth: 1
  property alias label: label

  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: borderWidth
    color: parent.color
  }

  Rectangle {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: borderWidth
    color: parent.color
  }

  Text {
    id: label
    color: Qt.rgba(0,0,0,0)
    anchors.fill: parent
    anchors.margins: 4
    antialiasing: true
    font.letterSpacing: 1
    font.pixelSize: 196
    font.bold: true
    fontSizeMode: Text.Fit
    verticalAlignment: Text.Center
    horizontalAlignment: Text.Center
    style: Text.Outline
    styleColor: parent.color
  }
  Glow {
    anchors.fill: label
    radius: 4
    samples: 16
    color: button.color
    source: label
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    onClicked: button.clicked()
  }

  Rectangle {
    z: -1
    anchors.fill: parent
    opacity: 0.3
    visible: mouseArea.pressed
    gradient: Gradient {
      GradientStop { color: "black"; position: 0 }
      GradientStop { color: Qt.darker(button.color); position: 0.5 }
      GradientStop { color: button.color; position: 1 }
    }
  }
}

/*Item {
    id: button
    property color color: "lightgrey"
    property alias label: labelText.text
    property alias sublabel: sublabelText.text
    property alias pressed: mouseArea.pressed
    property alias font: labelText.font
    property alias textColor: labelText.color
    property alias enabled: mouseArea.enabled
    property alias radius: bg.radius
    property alias border: bg.border
    signal clicked();

    width: 64
    height: 32

    Rectangle {
        id: bg
        anchors.fill: parent
        smooth: radius != 0

        property color c: button.enabled ? button.color : Qt.tint(button.color, "#88888888")

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker(bg.c, pressed ? 1.6 : 1.0 ) }
            GradientStop { position: pressed ? 0.2 : 0.8; color: Qt.darker(bg.c, pressed ? 1.4 : 1.2) }
            GradientStop { position: 1.0; color: Qt.darker(bg.c, pressed ? 1.2 : 1.4) }
        }

        clip: true

        Column {
          anchors.centerIn: parent
          Text {
              id: labelText
              font.pixelSize: 20
              text: button.label
              anchors.horizontalCenter: parent.horizontalCenter
              style: Text.Raised
              styleColor: "#111"
              color: "#ddd"
          }
          Text {
            id: sublabelText
            font.pixelSize: 14
            text: button.sublabel
            anchors.horizontalCenter: parent.horizontalCenter
            style: Text.Raised
            styleColor: "#111"
            color: "#ddd"
          }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: button.clicked()
        }

        Rectangle {
            width: parent.height
            height: 8
            visible: pressed
            transformOrigin: Rectangle.Bottom
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            rotation: 90
            radius: parent.radius

            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 1; color: Qt.rgba(0,0,0,0.2) }
            }
        }
        Rectangle {
            width: parent.height
            height: 8
            visible: pressed
            transformOrigin: Rectangle.Bottom
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.right
            rotation: -90
            radius: parent.radius

            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 1; color: Qt.rgba(0,0,0,0.2) }
            }
        }
    }

}

*/
