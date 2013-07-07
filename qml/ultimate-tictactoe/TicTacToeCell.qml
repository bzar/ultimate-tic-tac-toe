import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
  signal clicked()
  property int owner: 0
  property bool disabled: false

  Text {
    id: text
    anchors.centerIn: parent
    text: owner == 1 ? "X" : "O"
    color: owner == 1 ? "red" : "blue"
    visible: owner !== 0
    opacity: parent.opacity
    font.pixelSize: parent.height * 4 / 5
  }

  MouseArea {
    anchors.fill: parent
    enabled: !disabled
    onClicked: parent.clicked()
  }
}
