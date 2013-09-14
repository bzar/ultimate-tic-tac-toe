import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
  id: view

  property bool showAITest: false

  signal onePlayerGame
  signal twoPlayerGame
  signal aiTest
  signal quit

  Text {
    id: ultimate
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: view.height/8
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    horizontalAlignment: Text.Center

    text: "Ultimate"
    font.pixelSize: view.height/7
    fontSizeMode: Text.HorizontalFit
    color: Qt.rgba(0,0,0,0);
    style: Text.Outline
    styleColor: "#f66"
    opacity: 0.9
  }
  Text {
    id: tictactoe
    anchors.top: ultimate.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 8
    horizontalAlignment: Text.Center

    text: "Tic-Tac-Toe"
    font.pixelSize: view.height/8
    fontSizeMode: Text.HorizontalFit
    color: Qt.rgba(0,0,0,0);
    style: Text.Outline
    styleColor: "#66f"
  }

  Glow {
    anchors.fill: ultimate
    radius: 12
    samples: 16
    color: ultimate.styleColor
    source: ultimate
  }

  Glow {
    anchors.fill: tictactoe
    radius: 12
    samples: 16
    color: tictactoe.styleColor
    source: tictactoe
  }

  Column {
    id: buttons
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: tictactoe.bottom
    anchors.bottom: view.bottom
    anchors.topMargin: view.height/16
    anchors.bottomMargin: view.height/8
    spacing: view.height / 32

    Button {
      label.text: "1 player"
      width: 2 * view.width / 3
      height: view.height / 12
      onClicked: view.onePlayerGame()
    }

    Button {
      label.text: "2 players"
      width: 2 * view.width / 3
      height: view.height / 12
      onClicked: view.twoPlayerGame()
    }

    Button {
      visible: showAITest
      label.text: "AI Test"
      width: 2 * view.width / 3
      height: view.height / 12
      onClicked: view.aiTest()
    }

    Button {
      label.text: "Quit"
      width: 2 * view.width / 3
      height: view.height / 12
      onClicked: view.quit()
    }
  }
}
