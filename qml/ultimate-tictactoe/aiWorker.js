Qt.include("ai.js")

WorkerScript.onMessage = function(message) {
  var solution = think(message.aiType, message.board, message.previousMove, message.player);
  WorkerScript.sendMessage({solution: solution});
}
