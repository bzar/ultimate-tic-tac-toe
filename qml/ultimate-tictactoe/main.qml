import QtQuick 2.0
import "rules.js" as Rules

Rectangle {
  width: 360
  height: 360
  color: "#ccc"
  property int turn: 1

  Item {
    anchors.centerIn: parent
    width: Math.min(parent.width, parent.height)
    height: width

    TicTacToeCell {
      anchors.fill: parent
      owner: turn
      opacity: 0.3
      disabled: true
      animateOwnerChange: false
    }

    UltimateTicTacToeGrid {
      property var previous

      anchors.fill: parent
      anchors.margins: parent.width/20
      onClicked: {
        if(previous) {
          previous.highlighted = false;
        }

        var bigCell = getCell(bigCellIndex);
        var grid = bigCell.grid;
        var cell = grid.getCell(cellIndex);
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
        for(var i = 0; i < 9; ++i) {
          getCell(i).disabled = winner !== 0 || (i != nextBigCellIndex && nextBigCellHasRoom);
        }
      }
    }
  }
}
