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
              showQuit: false
              anchors.fill: parent

              onOnePlayerGame: {
                pageStack.push(difficultyPage)
              }

              onTwoPlayerGame: {
                gameView.singlePlayer = false;
                gameView.reset();
                pageStack.push(gamePage);
              }

              onAiTest: {
                  pageStack.push(aiTestPage)
              }
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
                      {i: 50, c: 1.4, n: 10},
                      {i: 500, c: 5, n: 50},
                      {i: 2000, c: 25, n: 100},
                      {i: 10000, c: 35, n: 100},
                      {i: 30000, c: 50, n: 100}
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
    Page {
        id: aiTestPage
        AITestView {
            anchors.centerIn: parent
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

