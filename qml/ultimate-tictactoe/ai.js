.pragma library

Qt.include("rules.js")

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

function think(aiType, board, previousMove, player) {
  if(aiType.type === "random") {
    return randomAI(board, previousMove, player);
  } else if(aiType.type === "greedy") {
    return greedyAI(board, previousMove, player);
  } else if(aiType.type === "montecarlo") {
    var func = customMontecarloAI(aiType.i, aiType.c, aiType.n, 1, -1, 0);
    return func(board, previousMove, player);
  } else {
    return montecarloAI(board, previousMove, player);
  }
}

function pickRandom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function determineOptions(board, previousMove) {
  var options = [];
  var enabled = determinePlayableGrids(board, previousMove);

  for(var ei = 0; ei < enabled.length; ++ei) {
    for(var ci = 0; ci < 9; ++ci) {
      var i = enabled[ei] * 3*3 + ci;

      if(board[i] === 0) {
        options.push(i);
      }
    }
  }

  return options;
}

function scoreBoard(board, player) {
  var score = 0;
  var bigGrid = [];
  for(var i = 0; i < 9; ++i) {
    var grid = board.slice(i*9, (i+1)*9);
    var winner = gridWinner(grid);
    bigGrid.push(winner);
    if(winner === 0) {
      score += scoreGrid(grid, player);
    }
  }

  score += 9 * scoreGrid(bigGrid, player);

  return score;
}

function scoreGrid(grid, player) {
  var lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical
    [0, 4, 8], [2, 4, 6]
  ]

  var score = 0;
  for(var i = 0; i < lines.length; ++i) {
    var line = lines[i];
    var lineScore = 0;
    for(var j = 0; j < line.length; ++j) {
      var owner = grid[line[j]];
      if(owner === player) {
        lineScore += 1;
      } else if(owner !== 0) {
        lineScore = 0;
        break;
      }
    }
    score += lineScore;
  }

  return score;
}

function otherPlayer(player) {
  return player === 1 ? 2 : 1;
}

function randomAI(board, previousMove, player) {
  var options = determineOptions(board, previousMove);
  return pickRandom(options);
}

function greedyAI(board, previousMove, player) {
  var options = determineOptions(board, previousMove);
  var bestOptions = [];
  var bestOptionScore = -200;

  for(var i = 0; i < options.length; ++i) {
    var option = options[i];
    var tempBoard = [].concat(board);
    tempBoard[option] = player;
    var score = scoreBoard(tempBoard, player) - scoreBoard(tempBoard, otherPlayer(player));
    if(score > bestOptionScore) {
      bestOptions = [option];
      bestOptionScore = score;
    } else if(score === bestOptionScore) {
      bestOptions.push(option);
    }
  }

  return pickRandom(bestOptions);
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

function montecarlo(n, bias, maxChildrenPerNode,
                    initialCtx, scoreFunc, optsFunc, playFunc) {

  function nodeUCBValue(node) {
    if(node.parent !== null) {
      return node.v + bias * Math.sqrt(Math.log(node.parent.n) / node.n);
    } else {
      return 0;
    }
  }

  function pickBestChild(node) {
    var bestChildValue;
    var bestChild;

    for(var i = 0; i < node.children.length; ++i) {
      var child = node.children[i];
      var childValue = nodeUCBValue(child);
      if(bestChildValue === undefined || childValue > bestChildValue) {
        bestChild = child;
        bestChildValue = childValue;
      }
    }
    return bestChild;
  }

  function select(node) {
    if(node.children.length === 0) {
      return node;
    }

    var bestChild = pickBestChild(node);

    return select(bestChild);
  }

  function expand(node) {
    var options = optsFunc(node.ctx);
    while(node.children.length < maxChildrenPerNode && options.length > 0) {
      var option = options.splice(Math.floor(Math.random() * options.length), 1)[0];
      var child = {
        parent: node,
        children: [],
        moves: node.moves.concat([option]),
        n: 1,
        v: 0,
        ctx: playFunc(node.ctx, [option])
      };
      node.children.push(child);
    }
    return node.children[0];
  }

  function simulate(node) {
    var ctxTemp = node.ctx;
    var running = true
    var score = null;
    var numberOfSteps = 0;

    while(score === null) {
      numberOfSteps += 1;
      var options = optsFunc(ctxTemp);
      var option = pickRandom(options);
      ctxTemp = playFunc(ctxTemp, [option]);
      score = scoreFunc(ctxTemp);
    }

    return score;
  }

  function backpropagate(node, score) {
    var n = node;
    while(n !== null) {
      n.n += 1;
      if(score !== null)
        n.v += score;
      n = n.parent;
    }
  }

  var root = {parent: null, children: [], moves: [], n: 1, v: 0, ctx: initialCtx}

  for(var i = 0; i < n || n < 0; ++i) {
    var leaf = select(root);
    var leafScore = scoreFunc(leaf.ctx);
    if(leafScore !== null) {
      break;
    }

    var node = expand(leaf);
    var score = simulate(node);
    backpropagate(node, score);
  }

  return pickBestChild(root).moves[0];
}

function customMontecarloAI(maxIterations, c, maxChildrenPerNode, winScore, loseScore, tieScore) {
  return function(board, previousMove, player) {
    function scoreFunc(ctx) {
      var bigGrid = [];
      for(var i = 0; i < 9; ++i) {
        var grid = ctx.board.slice(i*9, (i+1)*9);
        var winner = gridWinner(grid);
        bigGrid.push(winner !== null ? winner : 0);
      }

      var bigWinner = gridWinner(bigGrid);

      if(bigWinner === player) {
        return winScore;
      } else if(bigWinner === otherPlayer(player)){
        return loseScore;
      } else {
        var boardFull = true;
        for(i = 0; i < ctx.board.length; ++i) {
          if(ctx.board[i] === 0) {
            boardFull = false;
            break;
          }
        }

        return boardFull ? tieScore : null;
      }
    }

    function optsFunc(ctx) {
      return determineOptions(ctx.board, ctx.previousMove);
    }

    function playFunc(ctx, moves) {
      var newCtx = {
        board: [].concat(ctx.board),
        previousMove: ctx.previousMove
      }

      var turn = otherPlayer(ctx.board[ctx.previousMove]);

      for(var i = 0; i < moves.length; ++i) {
        var move = moves[i];
        newCtx.board[move] = turn;
        newCtx.previousMove = move;
        turn = otherPlayer(turn);
      }

      return newCtx;
    }

    var initialCtx = {board: board, previousMove: previousMove};
    var move = montecarlo(maxIterations, c, maxChildrenPerNode, initialCtx, scoreFunc, optsFunc, playFunc);
    return move;
  }
}

function montecarloAI(board, previousMove, player) {
  var func = customMontecarloAI(1000, 30, 10, 1, -1, 0);
  return func(board, previousMove, player);
}
