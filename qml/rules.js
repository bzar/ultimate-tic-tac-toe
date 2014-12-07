.pragma library

function gridWinner(c) {
    return gridWinnerWithOffset(c, 0);
}

function gridWinnerWithOffset(c, o) {
  // rows
  if(c[0+o] !== 0 && c[0+o] === c[1+o] && c[0+o] === c[2+o]) return c[0+o];
  if(c[3+o] !== 0 && c[3+o] === c[4+o] && c[3+o] === c[5+o]) return c[3+o];
  if(c[6+o] !== 0 && c[6+o] === c[7+o] && c[6+o] === c[8+o]) return c[6+o];

  // columns
  if(c[0+o] !== 0 && c[0+o] === c[3+o] && c[0+o] === c[6+o]) return c[0+o];
  if(c[1+o] !== 0 && c[1+o] === c[4+o] && c[1+o] === c[7+o]) return c[1+o];
  if(c[2+o] !== 0 && c[2+o] === c[5+o] && c[2+o] === c[8+o]) return c[2+o];

  // diagonals
  if(c[0+o] !== 0 && c[0+o] === c[4+o] && c[0+o] === c[8+o]) return c[0+o];
  if(c[6+o] !== 0 && c[6+o] === c[4+o] && c[6+o] === c[2+o]) return c[6+o];

  for(var i = 0; i < 9; ++i) {
    if(c[i+o] === 0) {
        return null;
    }
  }

  return 0;
}

function printBoard(b) {
  for(var y1 = 0; y1 < 3; ++y1) {
    for(var y2 = 0; y2 < 3; ++y2) {
      var x = y1*3*3*3 + y2*3;
      console.log(b[x+0] + " " + b[x+1] + " " + b[x+2] + " | " + b[x+9] + " " + b[x+10] + " " + b[x+11] + " | " + b[x+18] + " " + b[x+19] + " " + b[x+20])
    }
    console.log("------+-------+------")
  }
}

function boardWinner(board, bigGrid) {
  var bigWinner = gridWinner(bigGrid);

  if(bigWinner !== null && bigWinner !== 0) {
    //console.log("Winner: " + bigWinner + " | " + bigGrid)
    //printBoard(board)
    return bigWinner;
  }

  for(var i = 0; i < 9; ++i) {
    if(gridWinnerWithOffset(board, i*9) === null)
      return null;
  }

  //console.log("Board is full, tie");
  //printBoard(board);
  //console.log(bigGrid);
  return 0;
}

function determinePlayableGrids(board, previousMove) {
  var next = previousMove % 9;

  var hasRoom = false;
  for(var i = 0; i < 9; ++i) {
    if(board[next * 9 + i] === 0) {
      hasRoom = true;
      break;
    }
  }

  return hasRoom ? [next] : [0, 1, 2, 3, 4, 5, 6, 7, 8];
}

