import QtQuick 2.0

Item {
  id: component
  property alias grid: grid
  property alias cell: cell
  property alias disabled: grid.disabled
  property alias owner: cell.owner
  signal clicked(int cellIndex)

  TicTacToeCell {
    id: cell
    anchors.fill: parent
    disabled: true
    z: 1
    opacity: 0.9
  }

  TicTacToeGrid {
    id: grid
    anchors.fill: parent
    onClicked: component.clicked(cellIndex)
  }
}
