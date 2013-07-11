import QtQuick 2.0
import "rules.js" as Rules
import "ai.js" as AI

Item {
  id: view

  property bool singlePlayer: false

  signal done

  states: [
    State {
      name: "game"
      PropertyChanges { target: gameover; visible: false }
    },
    State {
      name: "gameover"
      PropertyChanges { target: gameover; visible: true }
    }
  ]

  state: "game"

  TicTacToeCell {
    anchors.fill: parent
    owner: game.turn
    opacity: 0.3
    disabled: true
    animateOwnerChange: false
  }

  MouseArea {
    id: gameover
    anchors.fill: parent
    onClicked: view.done()
  }

  UltimateTicTacToeGrid {
    id: game

    property int turn: 1
    property var previous

    anchors.fill: parent
    anchors.margins: parent.width/20
    onClicked: if(!singlePlayer || turn === 1) playTurn(bigCellIndex, cellIndex)

    function playTurn(bigCellIndex, cellIndex) {
      if(previous) {
        previous.highlighted = false;
      }

      var bigCell = getCell(bigCellIndex);
      var grid = bigCell.grid;
      var cell = grid.getCell(cellIndex);

      if(cell.disabled)
        return;

      cell.owner = turn;
      cell.highlighted = true;
      cell.disabled = true;
      previous = cell;

      if(bigCell.cell.owner === 0) {
        bigCell.cell.owner = Rules.gridWinner(grid.getOwnerArray())
      }

      var nextBigCellIndex = cellIndex;
      var nextBigCell = getCell(nextBigCellIndex);
      var nextGrid = nextBigCell.grid;

      var nextBigCellHasRoom = false;
      for(var i = 0; i < 9; ++i) {
        if(nextGrid.getCell(i).owner === 0) {
          nextBigCellHasRoom = true;
          break;
        }
      }

      var winner = Rules.gridWinner(getOwnerArray());

      turn = winner !== 0 ? winner : turn == 1 ? 2 : 1;
      for(i = 0; i < 9; ++i) {
        getCell(i).disabled = winner !== 0 || (i !== nextBigCellIndex && nextBigCellHasRoom);
      }

      if(winner !== 0) {
        view.state = "gameover";
      } else if(view.singlePlayer && turn === 2) {
        aiTimer.restart();
      }
    }

    Timer {
      id: aiTimer
      interval: 1000
      running: false
      onTriggered: {
        var board = [];
        var enabled = []

        for(var i = 0; i < 9; ++i) {
          board = board.concat(game.getCell(i).grid.getOwnerArray());
          if(!game.getCell(i).disabled) {
            enabled.push(i);
          }
        }

        var solution = AI.think(board, enabled);
        game.playTurn(Math.floor(solution / (3*3)), solution % (3*3));
      }
    }

    function reset() {
      view.state = "game"

      for(var i = 0; i < 9; ++i) {
        getCell(i).disabled = false;
        getCell(i).owner = 0;
        for(var j = 0; j < 9; ++j) {
          getCell(i).grid.getCell(j).owner = 0;
        }
      }
      turn = 1;
    }
  }

  function reset() {
    game.reset();
  }
}
