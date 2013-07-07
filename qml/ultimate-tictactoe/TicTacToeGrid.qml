import QtQuick 2.0

Grid {
  id: grid
  columns: 3
  spacing: width/20

  signal clicked(int cellIndex)
  property bool disabled: false

  function getCell(index) {
    return children[index].cell;
  }

  function getOwnerArray() {
    var owners = [];
    for(var i = 0; i < 9; ++i) {
      owners.push(getCell(i).owner);
    }
    return owners;
  }

  Repeater {
    model: 9
    delegate: Rectangle {
      property alias cell: cell
      color: "white"
      opacity: cell.disabled ? 0.9 : 1.0

      width: (grid.width - (grid.columns - 1) * grid.spacing) / grid.columns
      height: (grid.height - (grid.columns - 1) * grid.spacing) / grid.columns
      radius: height/10

      TicTacToeCell {
        id: cell
        anchors.fill: parent
        disabled: grid.disabled
        onClicked: grid.clicked(index)
      }
    }
  }
}
