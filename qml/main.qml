import QtQuick 2.0
import "rules.js" as Rules
import Sailfish.Silica 1.0

ApplicationWindow
{
    Component {
        id: titlePage
        Page {
            TitleView {
              id: titleView
              showAITest: false
              anchors.fill: parent

              onOnePlayerGame: {
                pageStack.push(difficultyPage)
              }

              onTwoPlayerGame: {
                gameView.singlePlayer = false;
                gameView.reset();
                pageStack.push(gamePage);
              }

              onQuit: Qt.quit()
            }
        }
    }
    Component {
        id: difficultyPage
        Page {
            DifficultySelectView {
              id: difficultySelectView
              anchors.fill: parent
              onSelect: {
                var aiTypes = [
                      {i: 100, c: 10, n: 5},
                      {i: 500, c: 15, n: 10},
                      {i: 1000, c: 30, n: 10},
                      {i: 5000, c: 150, n: 10},
                      {i: 10000, c: 300, n: 10}
                ];
                gameView.aiType = aiTypes[level];
                gameView.singlePlayer = true;
                gameView.reset();
                pageStack.push(gamePage);
              }
            }
        }
    }
    Page {
        id: gamePage
        GameView {
          id: gameView
          anchors.centerIn: parent
          width: Math.min(parent.width, parent.height)
          height: width
        }
    }

    initialPage: titlePage

    cover: CoverBackground {
        Column {
            anchors.centerIn: parent
            Label {
                text: qsTr("Ultimate")
            }
            Label {
                text: qsTr("Tic-Tac-Toe")
            }
        }
    }
}

