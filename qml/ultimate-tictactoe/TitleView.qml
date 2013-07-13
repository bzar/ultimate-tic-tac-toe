import QtQuick 2.0

Item {
  id: view

  signal onePlayerGame
  signal twoPlayerGame
  signal aiTest
  signal quit

  Column {
    id: titleText
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: view.height/8

    Text {
      id: ultimate
      text: "Ultimate"
      font.pixelSize: view.height/8
      fontSizeMode: Text.HorizontalFit
      horizontalAlignment: Text.Center
      width: view.width
      color: "#eee"
      style: Text.Outline
      styleColor: "darkred"
    }
    Text {
      id: tictactoe
      text: "Tic-Tac-Toe"
      font.pixelSize: view.height/8
      horizontalAlignment: Text.Center
      fontSizeMode: Text.HorizontalFit
      width: view.width
      color: "#eee"
      style: Text.Outline
      styleColor: "darkblue"
    }
  }

  Column {
    id: buttons
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: titleText.bottom
    anchors.bottom: view.bottom
    anchors.topMargin: view.height/8
    anchors.bottomMargin: view.height/8
    spacing: view.height / 32

    Button {
      label: "1 player"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.onePlayerGame()
    }

    Button {
      label: "2 players"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.twoPlayerGame()
    }
/*
    Button {
      label: "AI Test"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.aiTest()
    }
*/
    Button {
      label: "Quit"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.quit()
    }
  }
}
