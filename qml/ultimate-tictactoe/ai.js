.pragma library

/**
  * Board must be in array format with 0, 1 or 2 in each cell
  * Array index is 3*3*3*by + 3*3*bx + 3*y + x,
  * where (bx, by) is the big grid coordinates and
  * (x, y) little grid coordinates
  *
  * [100]|[000]|[000]
  * [010]|[000]|[000]   index order
  * [000]|[000]|[000]   [012]
  * -----+-----+-----   [345]
  * [000]|[200]|[000]   [678]
  * [000]|[020]|[000]
  * [000]|[000]|[000]
  * -----+-----+-----
  * [000]|[000]|[000]
  * [000]|[000]|[000]
  * [000]|[000]|[000]
  *
  * enabled is an array of big grid indices to which the AI can play
  */

function think(board, enabled) {
  return randomAI(board, enabled);
}

function randomAI(board, enabled) {
  var options = [];

  for(var ei = 0; ei < enabled.length; ++ei) {
    for(var ci = 0; ci < 9; ++ci) {
      var i = enabled[ei] * 3*3 + ci;

      if(board[i] === 0) {
        options.push(i);
      }
    }
  }

  var solutionIndex = Math.floor(Math.random() * options.length);
  return options[solutionIndex];
}

function index2coords(index) {
  return {
    by: index / (3*3*3),
    bx: (index % (3*3*3)) / (3*3),
    y: (index % (3*3)) / 3,
    x: index % 3
  }
}

function coords2index(bx, by, bx, y) {
  if(by !== undefined) {
    return by*3*3*3 + bx*3*3 + y*3 + x;
  } else {
    return bx.by*3*3*3 + bx.bx*3*3 + bx.y*3 + bx.x;
  }
}
