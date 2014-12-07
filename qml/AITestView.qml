import QtQuick 2.0
import "rules.js" as Rules
import UltimateTicTacToeAI 1.0

Item {
  property variant board;
  property variant bigGrid;
  property int previousMove;
  property int turn;
  property int ai1Wins: 0;
  property int ai2Wins: 0;
  property int ties: 0;
  property int games: ai1Wins + ai2Wins + ties;
  property int n: 10;

  width: childrenRect.width
  height: childrenRect.height

  function initialize() {
    var b = [];
    var i;
    for(i = 0; i < 9*9; ++i) {
      b.push(0);
    }
    board = b;

    var bg = [];
    for(i = 0; i < 9; ++i) {
      bg.push(0);
    }
    bigGrid = bg;

    turn = (games % 2) + 1;
    previousMove = -1;
  }

  function play(player, move) {
    var gridIndex = parseInt(move / 9);
    var b = board;
    b[move] = player;
    board = b;

    if(bigGrid[gridIndex] === 0) {
      var gridWinner = Rules.gridWinnerWithOffset(board, gridIndex*9);
      if(gridWinner !== null) {
        var bg = bigGrid;
        bg[gridIndex] = gridWinner;
        bigGrid = bg;
      }
    }

    var winner = Rules.boardWinner(board, bigGrid);

    if(winner !== null) {
      if(winner === 1) {
        ai1Wins += 1;
      } else if(winner === 2) {
        ai2Wins += 1;
      } else {
        ties += 1;
      }

      if(ai1Wins + ai2Wins + ties < n) {
        start();
      }
    } else {
      previousMove = move;
      turn = turn === 1 ? 2 : 1;
      if(turn === 1) {
        ai1.think(board, bigGrid, previousMove, turn);
      } else {
        ai2.think(board, bigGrid, previousMove, turn);
      }
    }
  }

  function reset() {
    ai1Wins = 0;
    ai2Wins = 0;
    ties = 0;
  }

  function start() {
    initialize();
    ai1.think(board, bigGrid, previousMove, turn);
  }

  Montecarlo {
    id: ai1
    maxIterations: parseInt(i1.text)
    c: parseFloat(c1.text)
    maxChildren: parseInt(n1.text)
    onResult: play(1, move);
  }

  Montecarlo {
    id: ai2
    maxIterations: parseInt(i2.text)
    c: parseFloat(c2.text)
    maxChildren: parseInt(n2.text)
    onResult: play(2, move);
  }

  Column {
    spacing: 8
    Row {
      spacing: 8
      Column {
        spacing: 8
        Text {
          text: "AI 1"
          color: "white"
        }
        Row {
          spacing: 8
          Text {
            text: "i:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: i1
              text: "500"
            }
          }
        }
        Row {
          spacing: 8
          Text {
            text: "c:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: c1
              text: "15"
            }
          }

        }
        Row {
          spacing: 8
          Text {
            text: "n:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: n1
              text: "10"
            }
          }
        }
      }
      Column {
        spacing: 8
        Text {
          text: "AI 2"
          color: "white"
        }
        Row {
          spacing: 8
          Text {
            text: "i:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: i2
              text: "500"
            }
          }
        }
        Row {
          spacing: 8
          Text {
            text: "c:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: c2
              text: "15"
            }
          }
        }
        Row {
          spacing: 8
          Text {
            text: "n:"
            color: "white"
          }

          Rectangle {
            color: "white"
            width: 64
            height: 16
            TextInput {
              anchors.fill: parent
              id: n2
              text: "10"
            }
          }
        }
      }
    }

    Row {
      spacing: 8
      Text {
        text: "N:"
        color: "white"
      }

      Rectangle {
        color: "white"
        width: 64
        height: 16
        TextInput {
          anchors.fill: parent
          text: n
          onTextChanged: n = parseInt(text)
        }
      }
    }
    Button {
      label.text: "Run AI test"
      onClicked: {
        reset();
        start();
      }
    }

    Text {
      color: "white"
      text: games + "/" + n
      font.pixelSize: 20
    }

    Row {
      Text {
        color: "white"
        text: ai1Wins
        font.pixelSize: 20
      }
      Text {
        color: "white"
        text: "-"
        font.pixelSize: 20
      }
      Text {
        color: "white"
        text: ties
        font.pixelSize: 20
      }
      Text {
        color: "white"
        text: "-"
        font.pixelSize: 20
      }
      Text {
        color: "white"
        text: ai2Wins
        font.pixelSize: 20
      }
    }
  }
}
