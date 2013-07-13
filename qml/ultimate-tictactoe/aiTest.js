Qt.include("ai.js")

var AIS = {
  random: randomAI,
  greedy: greedyAI,
  montecarlo: customMontecarloAI(5000, 150, 10, 1, -1, 0),
  montecarlo1: customMontecarloAI(1000, 30, 10, 1, -1, 0),
  montecarlo2: customMontecarloAI(5000, 150, 10, 1, -1, 0)
}

WorkerScript.onMessage = function(message) {
  var reply = {request: message, ai1: 0, ai2: 0, ties: 0};

  for(var i = 0; i < message.n; ++i) {
    var swap = i%2 === 1;
    var ai1 = swap ? message.ai2 : message.ai1;
    var ai2 = swap ? message.ai1 : message.ai2;
    var result = runGame(AIS[ai1], AIS[ai2]);

    if(result === (swap ? 2 : 1)) {
      reply.ai1 += 1;
    } else if(result === (swap ? 1 : 2)) {
      reply.ai2 += 1;
    } else {
      reply.ties += 1;
    }
    WorkerScript.sendMessage(reply);
  }
}

function runGame(aiFunc1, aiFunc2) {
  var board = [];
  for(var i = 0; i < 9*9; ++i) {
    board.push(0);
  }

  var turn = 1;
  var lastMove = null;
  while(boardWinner(board) === null) {
    var move = turn === 1 ? aiFunc1(board, lastMove, 1) : aiFunc2(board, lastMove, 2);
    board[move] = turn;
    lastMove = move;
    turn = turn === 1 ? 2 : 1;
  }

  return boardWinner(board);
}

