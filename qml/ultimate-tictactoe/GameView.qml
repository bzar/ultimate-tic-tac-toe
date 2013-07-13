import QtQuick 2.0
import "rules.js" as Rules

Item {
  id: view

  property bool singlePlayer: false
  property var aiType

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
    opacity: 0.7
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
    property int previousMove

    anchors.fill: parent
    anchors.margins: 8
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
      previous = cell;
      previousMove = bigCellIndex * 9 + cellIndex;

      if(bigCell.cell.owner === 0) {
        var gridWinner = Rules.gridWinner(grid.getOwnerArray());
        bigCell.cell.owner = gridWinner === null ? 0 : gridWinner;
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

      turn = winner !== null && winner !== 0 ? winner : turn == 1 ? 2 : 1;
      for(i = 0; i < 9; ++i) {
        getCell(i).disabled = winner !== null || (i !== nextBigCellIndex && nextBigCellHasRoom);
      }

      if(winner !== null) {
        view.state = "gameover";
      } else if(view.singlePlayer && turn === 2) {
        aiTimer.restart();
      }
    }

    Timer {
      id: aiTimer
      interval: 500
      running: false
      onTriggered: {
        var board = [];

        for(var i = 0; i < 9; ++i) {
          board = board.concat(game.getCell(i).grid.getOwnerArray());
        }

        aiWorker.sendMessage({aiType: aiType,
                               board: board,
                               previousMove: game.previousMove,
                               player: 2});
      }
    }

    WorkerScript {
      id: aiWorker
      source: "aiWorker.js"
      onMessage: {
        var solution = messageObject.solution;
        var bigCellIndex = Math.floor(solution / (3*3));
        var cellIndex = solution % (3*3);
        game.playTurn(bigCellIndex, cellIndex);
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
      previous = null;
      previousMove = 0;
    }
  }

  function reset() {
    game.reset();
  }
}
