import QtQuick 2.0
import "rules.js" as Rules
import UltimateTicTacToeAI 1.0

Item {
  id: view

  function defaultAiType() {
    return {i: 500, c: 15, n: 10};
  }

  property bool singlePlayer: false
  property var aiType: defaultAiType()
  property bool aiIsThinking: false

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
      var winner = Rules.gridWinner(getOwnerArray());

      turn = winner !== null && winner !== 0 ? winner : turn == 1 ? 2 : 1;
      for(var i = 0; i < 9; ++i) {
        getCell(i).disabled = winner !== null || (i !== nextBigCellIndex && nextBigCell.owner === 0);
      }

      if(winner !== null) {
        view.state = "gameover";
      } else if(view.singlePlayer && turn === 2) {
        aiTimer.restart();
      }
    }

    Montecarlo {
      id: ai
      c: view.aiType.c
      maxIterations: view.aiType.i
      maxChildren: view.aiType.n
      onResult: {
        aiIsThinking = false;
        var bigCellIndex = Math.floor(move / (3*3));
        var cellIndex = move % (3*3);
        game.playTurn(bigCellIndex, cellIndex);
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

        aiIsThinking = true;
        ai.think(board, game.getOwnerArray(), game.previousMove, 2);
      }
    }

    WorkerScript {
      id: aiWorker
      source: "aiWorker.js"
      onMessage: {
        aiIsThinking = false;
        var solution = messageObject.solution;
        var bigCellIndex = Math.floor(solution / (3*3));
        var cellIndex = solution % (3*3);
        game.playTurn(bigCellIndex, cellIndex);
      }
    }

    Image {
      id: thinkingIndicator
      source: "cog.png"
      visible: aiIsThinking
      anchors.top: parent.top
      anchors.right: parent.right
      NumberAnimation on rotation {
        from: 0
        to: 360
        duration: 3000
        loops: Animation.Infinite
        running: thinkingIndicator.visible
      }
      SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: thinkingIndicator.visible
        NumberAnimation { from: 0.5; to: 1; duration: 500; easing.type: Easing.OutCubic }
        NumberAnimation { from: 1; to: 0.5; duration: 500; easing.type: Easing.InCubic }
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
