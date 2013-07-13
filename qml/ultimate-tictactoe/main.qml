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
      PropertyChanges { target: aiTestView; visible: false }
      PropertyChanges { target: difficultySelectView; visible: false }
    },
    State {
      name: "game"
      PropertyChanges { target: titleView; visible: false }
      PropertyChanges { target: gameView; visible: true }
      PropertyChanges { target: aiTestView; visible: false }
      PropertyChanges { target: difficultySelectView; visible: false }
    },
    State {
      name: "aitest"
      PropertyChanges { target: titleView; visible: false }
      PropertyChanges { target: gameView; visible: false }
      PropertyChanges { target: aiTestView; visible: true }
      PropertyChanges { target: difficultySelectView; visible: false }
    },
    State {
      name: "difficulty"
      PropertyChanges { target: titleView; visible: false }
      PropertyChanges { target: gameView; visible: false }
      PropertyChanges { target: aiTestView; visible: false }
      PropertyChanges { target: difficultySelectView; visible: true }
    }
  ]

  state: "title"

  TitleView {
    id: titleView
    anchors.fill: parent

    onOnePlayerGame: {
      app.state = "difficulty"
    }

    onTwoPlayerGame: {
      gameView.singlePlayer = false;
      gameView.reset();
    }

    onQuit: Qt.quit()
    onAiTest: app.state = "aitest"
  }

  DifficultySelectView {
    id: difficultySelectView
    anchors.fill: parent
    onSelect: {
      var aiTypes = [
            {type: "greedy"},
            {type: "montecarlo", i: 100, c: 10, n: 10},
            {type: "montecarlo", i: 500, c: 15, n: 10},
            {type: "montecarlo", i: 1000, c: 30, n: 10},
            {type: "montecarlo", i: 5000, c: 150, n: 10}
      ]
      gameView.aiType = aiTypes[level];
      gameView.singlePlayer = true;
      gameView.reset();
      app.state = "game"
    }
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
