import QtQuick 2.0
import "rules.js" as Rules

Rectangle {
  id: app
  width: 480
  height: 480
  gradient: Gradient {
    GradientStop { color: "#ccc"; position: 0 }
    GradientStop { color: "#666"; position: 1 }
  }

  states: [
    State {
      name: "title"
      PropertyChanges { target: titleView; visible: true }
      PropertyChanges { target: gameView; visible: false }
    },
    State {
      name: "game"
      PropertyChanges { target: titleView; visible: false }
      PropertyChanges { target: gameView; visible: true }
    },
    State {
      name: "aitest"
      PropertyChanges { target: titleView; visible: false }
      PropertyChanges { target: gameView; visible: false }
      PropertyChanges { target: aiTestView; visible: true }
    }
  ]

  state: "aitest"

  TitleView {
    id: titleView
    anchors.fill: parent

    onOnePlayerGame: {
      gameView.singlePlayer = true;
      gameView.reset();
      app.state = "game"
    }

    onTwoPlayerGame: {
      gameView.singlePlayer = false;
      gameView.reset();
      app.state = "game"
    }

    onQuit: Qt.quit()
  }

  GameView {
    id: gameView
    anchors.centerIn: parent
    width: Math.min(parent.width, parent.height)
    height: width
    visible: false
    onDone: app.state = "title"
  }

  AITestView {
    id: aiTestView
    anchors.fill: parent
  }
}
