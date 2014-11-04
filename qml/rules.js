.pragma library

function gridWinner(c) {
  // rows
  if(c[0] !== 0 && c[0] === c[1] && c[0] === c[2]) return c[0];
  if(c[3] !== 0 && c[3] === c[4] && c[3] === c[5]) return c[3];
  if(c[6] !== 0 && c[6] === c[7] && c[6] === c[8]) return c[6];

  // columns
  if(c[0] !== 0 && c[0] === c[3] && c[0] === c[6]) return c[0];
  if(c[1] !== 0 && c[1] === c[4] && c[1] === c[7]) return c[1];
  if(c[2] !== 0 && c[2] === c[5] && c[2] === c[8]) return c[2];

  // diagonals
  if(c[0] !== 0 && c[0] === c[4] && c[0] === c[8]) return c[0];
  if(c[6] !== 0 && c[6] === c[4] && c[6] === c[2]) return c[6];

  var boardFull = true;
  for(var i = 0; i < c.length; ++i) {
    if(c[i] === 0) {
      boardFull = false;
      break;
    }
  }

  return boardFull ? 0 : null;
}

function boardWinner(board, bigGrid) {
  var bigWinner = gridWinner(bigGrid);

  if(bigWinner !== null && bigWinner !== 0) {
    return bigWinner;
  } else {
    var boardFull = true;
    for(var i = 0; i < board.length; ++i) {
      if(board[i] === 0) {
        boardFull = false;
        break;
      }
    }

    return boardFull ? 0 : null;
  }

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

