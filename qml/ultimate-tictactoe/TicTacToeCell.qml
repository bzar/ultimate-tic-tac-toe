import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
  id: cell

  signal clicked()
  property int owner: 0
  property bool disabled: false
  property bool highlighted: false
  property bool animateOwnerChange: true

  Text {
    id: text
    anchors.centerIn: parent
    text: owner == 1 ? "X" : "O"
    color: owner == 1 ? "red" : "blue"
    visible: owner !== 0
    opacity: parent.opacity
    font.pixelSize: parent.height * 4 / 5
  }

  Text {
    id: textClone
    anchors.centerIn: parent
    text: text.text
    color: text.color
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
