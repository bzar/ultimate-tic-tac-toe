import QtQuick 2.0

Item {
  id: component
  signal clicked(int bigCellIndex, int cellIndex)

  function getCell(index) {
    return bigGrid.children[index].cell;
  }

  function getOwnerArray() {
    var owners = [];
    for(var i = 0; i < 9; ++i) {
      owners.push(getCell(i).owner);
    }
    return owners;
  }

  Grid {
    id: bigGrid
    anchors.fill: parent
    columns: 3
    spacing: width/60

    Repeater {
      model: 9
      delegate: Rectangle {
        id: delegate
        property alias cell: cell
        color: Qt.rgba(0,0,0,0)

        Behavior on opacity {
          NumberAnimation { duration: 100 }
        }
        width: (bigGrid.width - (bigGrid.columns - 1) * bigGrid.spacing) / bigGrid.columns
        height: (bigGrid.height - (bigGrid.columns - 1) * bigGrid.spacing) / bigGrid.columns
        radius: parent.width / 60
        border.color: cell.disabled ? "#444" : "#ccc"
        border.width: cell.disabled ? 1 : width/40

        UltimateTicTacToeCell {
          id: cell
          anchors.fill: parent
          anchors.margins: parent.width / 20
          onClicked: component.clicked(index, cellIndex)
        }
      }
    }
  }
}
