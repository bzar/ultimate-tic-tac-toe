import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
  id: cell

  signal clicked()
  property int owner: 0
  property bool disabled: false
  property bool highlighted: false
  property bool animateOwnerChange: true
  property color color: owner == 1 ? "#f66" : owner == 2 ? "#66f" : "white"

  Text {
    id: text
    anchors.centerIn: parent
    text: owner == 1 ? "X" : "O"
    color: Qt.rgba(0,0,0,0)
    font.bold: true
    style: Text.Outline
    styleColor: cell.color
    visible: owner !== 0
    opacity: parent.opacity
    font.pixelSize: parent.height * 4 / 5
  }
  Glow {
    anchors.fill: text
    visible: text.visible
    radius: 8
    samples: 16
    color: cell.color
    source: text
  }
  Text {
    id: textClone
    anchors.centerIn: parent
    text: text.text
    color: Qt.rgba(0,0,0,0)
    style: Text.Outline
    styleColor: cell.color
    font.pixelSize: text.font.pixelSize
    visible: false
  }

  onOwnerChanged: { if(animateOwnerChange && owner !== 0) ownerChangeAnimation.start() }

  SequentialAnimation {
    id: ownerChangeAnimation
    PropertyAnimation { target: text; properties: "visible"; to: true; duration: 0 }
    PropertyAnimation { target: textClone; properties: "visible"; to: true; duration: 0 }
    ParallelAnimation {
      NumberAnimation { target: text; properties: "opacity"; from: 0; to: 1; duration: 1000 }
      NumberAnimation { target: textClone; properties: "opacity"; from: 0.8; to: 0; duration: 1000 }
      NumberAnimation { target: textClone; properties: "scale"; from: 1; to: 3; duration: 1000 }
    }
    PropertyAnimation { target: textClone; properties: "visible"; to: false; duration: 0 }
  }

  MouseArea {
    anchors.fill: parent
    enabled: !cell.disabled
    onClicked: parent.clicked()
  }
}
