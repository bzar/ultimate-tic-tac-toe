import QtQuick 2.0
import "rules.js" as Rules

Rectangle {
  id: app
  width: 480
  height: 480
  gradient: Gradient {
    GradientStop { color: "#444"; position: 0 }
    GradientStop { color: "#111"; position: 1 }
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
  focus: true

  // Workaround for application segfaulting if Qt.quit is called inside Keys.onPressed
  Timer {
    id: quitHack
    interval: 1
    onTriggered: Qt.quit();
  }

  Keys.onPressed: {
    // Depends on android/qtproject/qt5/android/bindings/QtActivity.java back button hack
    if(event.key === Qt.Key_MediaPrevious || event.key === Qt.Key_Escape) {
      if(app.state !== "title") {
        app.state = "title";
        event.accepted = true;
      } else {
        quitHack.start();
      }
    }
  }

  TitleView {
    id: titleView
    anchors.fill: parent

    onOnePlayerGame: {
      app.state = "difficulty"
    }

    onTwoPlayerGame: {
      gameView.singlePlayer = false;
      gameView.reset();
      app.state = "game"
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
            {type: "montecarlo", i: 500, c: 15, n: 10},
            {type: "montecarlo", i: 1000, c: 30, n: 10},
            {type: "montecarlo", i: 5000, c: 150, n: 10},
            {type: "montecarlo", i: 10000, c: 300, n: 10}
      ];
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
