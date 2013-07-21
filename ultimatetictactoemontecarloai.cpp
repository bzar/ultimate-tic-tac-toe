#include "ultimatetictactoemontecarloai.h"
#include <qmath.h>
#include <QDebug>
#include <QDateTime>
#include <QtConcurrent/QtConcurrent>

int const GRID_SIZE  = 9;
int const BOARD_SIZE  = GRID_SIZE * GRID_SIZE;


int UltimateTicTacToeMontecarloAI::scoreBoard(Board const& board, int const player) const
{
  int score = 0;
  for(int i = 0; i < GRID_SIZE; ++i)
  {
    if(board.bigGrid.at(i) == 0)
    {
      score += scoreGrid(board.grids, player, i);
    }
  }

  score += 9 * scoreGrid(board.bigGrid, player);

  return score;
}

int UltimateTicTacToeMontecarloAI::scoreGrid(Grid const& grid, int const player, int const gridIndex) const
{
  int lines[][3] = {
    {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // horizontal
    {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // vertical
    {0, 4, 8}, {2, 4, 6}
  };

  int score = 0;
  for(int i = 0; i < 8; ++i) {
    int lineScore = 0;
    for(int j = 0; j < 3; ++j) {
      int owner = grid.at(GRID_SIZE * gridIndex + lines[i][j]);
      if(owner == player) {
        lineScore += 1;
      } else if(owner != 0) {
        lineScore = 0;
        break;
      }
    }
    score += lineScore;
  }

  return score;
}

qreal UltimateTicTacToeMontecarloAI::nodeUCBValue(Node const& node, Nodes const& nodes) const {
  if(node.parent != -1)
  {
    return node.v + c * qSqrt(qLn(nodes.at(node.parent).n) / node.n);
  } else {
    return 0;
  }
}

int UltimateTicTacToeMontecarloAI::pickBestChild(Node const& node, Nodes const& nodes, bool const ucb) const
{
  bool first = true;
  qreal bestChildValue = 0;
  int bestChildIndex = 0;

  for(int const childIndex : node.children)
  {
    Node const& child = nodes.at(childIndex);
    qreal childValue = ucb ? nodeUCBValue(child, nodes) : child.v / static_cast<qreal>(child.n);
    if(first || childValue >= bestChildValue) {
      bestChildIndex = childIndex;
      bestChildValue = childValue;
      first = false;
    }
  }

  return bestChildIndex;
}

int UltimateTicTacToeMontecarloAI::select(Nodes const& nodes, int const current) const
{
  Node const& node = nodes.at(current);
  if(node.children.empty())
    return current;

  return select(nodes, pickBestChild(node, nodes));
}

UltimateTicTacToeMontecarloAI::Moves UltimateTicTacToeMontecarloAI::movementOptions(Board const& board, int const previousMove) const
{
  int grid = previousMove % GRID_SIZE;
  Moves options;
  options.reserve(9);

  for(int i = 0; i < GRID_SIZE; ++i)
  {
    int position = grid * GRID_SIZE + i;
    if(board.grids.at(position) == 0)
    {
      options.append(position);
    }
  }

  if(options.empty())
  {
    for(int i = 0; i < BOARD_SIZE; ++i)
    {
      if(board.grids.at(i) == 0)
      {
        options.append(i);
      }
    }
  }

  return options;
}

UltimateTicTacToeMontecarloAI::Board& UltimateTicTacToeMontecarloAI::playMove(Board& board, Move const move, int const player) const
{
  board.grids[move] = player;
  int gridIndex = move / GRID_SIZE;
  if(board.bigGrid.at(gridIndex) == 0)
  {
    int smallGridWinner = gridWinner(board.grids, gridIndex);
    if(smallGridWinner != 0)
    {
      board.bigGrid[gridIndex] = smallGridWinner;
    }
  }
  return board;
}

int UltimateTicTacToeMontecarloAI::otherPlayer(int const player) const
{
  return player == 1 ? 2 : 1;
}

int UltimateTicTacToeMontecarloAI::gridWinner(Grid const& grid, int gridIndex) const
{
  int o = gridIndex * GRID_SIZE;
  // rows
  if(grid.at(o+0) != 0 && grid.at(o+0) == grid.at(o+1) && grid.at(o+0) == grid.at(o+2)) return grid.at(o+0);
  if(grid.at(o+3) != 0 && grid.at(o+3) == grid.at(o+4) && grid.at(o+3) == grid.at(o+5)) return grid.at(o+3);
  if(grid.at(o+6) != 0 && grid.at(o+6) == grid.at(o+7) && grid.at(o+6) == grid.at(o+8)) return grid.at(o+6);

  // columns
  if(grid.at(o+0) != 0 && grid.at(o+0) == grid.at(o+3) && grid.at(o+0) == grid.at(o+6)) return grid.at(o+0);
  if(grid.at(o+1) != 0 && grid.at(o+1) == grid.at(o+4) && grid.at(o+1) == grid.at(o+7)) return grid.at(o+1);
  if(grid.at(o+2) != 0 && grid.at(o+2) == grid.at(o+5) && grid.at(o+2) == grid.at(o+8)) return grid.at(o+2);

  // diagonals
  if(grid.at(o+0) != 0 && grid.at(o+0) == grid.at(o+4) && grid.at(o+0) == grid.at(o+8)) return grid.at(o+0);
  if(grid.at(o+6) != 0 && grid.at(o+6) == grid.at(o+4) && grid.at(o+6) == grid.at(o+2)) return grid.at(o+6);

  return 0;
}

int UltimateTicTacToeMontecarloAI::expand(int leafIndex, Nodes& nodes, int const player) const
{
  Node& node = nodes[leafIndex];
  node.children.reserve(maxChildren);
  Moves options = movementOptions(node.board, node.previousMove);
  int turn = otherPlayer(node.board.grids.at(node.previousMove));

  int mostPromisingChildIndex = -1;
  int mostPromisingChildScore = 0;

  while(node.children.size() < maxChildren && !options.empty())
  {
    Move move = options.takeAt(qrand() % options.size());
    int childIndex = nodes.size();
    node.children.append(childIndex);
    Board newBoard(node.board);
    nodes.append( Node {0, 1, playMove(newBoard, move, turn), move, leafIndex, Node::Children()});
    int score = scoreBoard(nodes.last().board, player);
    if(score > mostPromisingChildScore || mostPromisingChildIndex < 0)
    {
      mostPromisingChildIndex = childIndex;
      mostPromisingChildScore = score;
    }
  }

  return mostPromisingChildIndex;
}

bool UltimateTicTacToeMontecarloAI::boardFull(Board const& board) const
{
  for(int const& v : board.grids)
  {
    if(v == 0)
    {
      return false;
    }
  }
  return true;
}

UltimateTicTacToeMontecarloAI::GameState UltimateTicTacToeMontecarloAI::gameState(Board const& board, int player) const
{
  int winner = gridWinner(board.bigGrid);

  if(winner == player)
  {
    return GameState::WIN;
  }
  else if(winner == otherPlayer(player))
  {
    return GameState::LOSE;
  }
  else if(boardFull(board))
  {
    return GameState::TIE;
  }
  else
  {
    return GameState::UNRESOLVED;
  }
}

void UltimateTicTacToeMontecarloAI::printBoard(const UltimateTicTacToeMontecarloAI::Board &board) const
{
  for(int y = 0; y < 3; ++y)
  {
    for(int y2 = 0; y2 < 3; ++y2)
    {
      int o = y*3*GRID_SIZE + y2*3;
      qDebug() << board.grids.at(o) << board.grids.at(o+1) << board.grids.at(o+2) << " "
               << board.grids.at(o+9)<< board.grids.at(o+10)<< board.grids.at(o+11) << " "
               << board.grids.at(o+18)<< board.grids.at(o+19)<< board.grids.at(o+20) << " ";
    }
    qDebug() << " ";
  }

  qDebug() << "* * * *";
  for(int y = 0; y < 3; ++y)
  {
    qDebug() << "*" << board.bigGrid.at(y*3) << board.bigGrid.at(y*3+1) << board.bigGrid.at(y*3+2);
  }
}

int UltimateTicTacToeMontecarloAI::simulate(Board board, int const previousMove, int const player) const
{
  int turn = otherPlayer(board.grids.at(previousMove));
  GameState state = gameState(board, player);
  Move prev = previousMove;
  while(state == GameState::UNRESOLVED)
  {
    Moves options = movementOptions(board, prev);
    Move option = options.at(qrand() % options.size());
    playMove(board, option, turn);
    turn = otherPlayer(turn);
    state = gameState(board, player);
    prev = option;
  }

  switch(state)
  {
    case GameState::WIN: return 1;
    case GameState::LOSE: return -1;
    default: return 0;
  }
}

void UltimateTicTacToeMontecarloAI::backpropagate(int const nodeIndex, Nodes& nodes, int const score) const
{
  int n = nodeIndex;
  while(n >= 0)
  {
    Node& node = nodes[n];
    node.v += score;
    node.n += 1;
    n = node.parent;
  }
}

UltimateTicTacToeMontecarloAI::UltimateTicTacToeMontecarloAI(QObject *parent) :
  QObject(parent)
{
  connect(&futureWatcher, &QFutureWatcher<int>::finished, [&]() {
    emit this->result(futureWatcher.future().result());
  });
}

void UltimateTicTacToeMontecarloAI::think(QVariantList board, QVariantList bigGrid, int previousMove, int player)
{
  Board b;
  b.grids.reserve(BOARD_SIZE);
  for(int i = 0; i < BOARD_SIZE; ++i) {
    b.grids.append(qvariant_cast<int>(board.at(i)));
  }

  b.bigGrid.reserve(GRID_SIZE);
  for(int i = 0; i < GRID_SIZE; ++i) {
    b.bigGrid.append(qvariant_cast<int>(bigGrid.at(i)));
  }

  futureWatcher.setFuture(QtConcurrent::run(this, &UltimateTicTacToeMontecarloAI::realThink, b, previousMove, player));
}

int UltimateTicTacToeMontecarloAI::realThink(const UltimateTicTacToeMontecarloAI::Board &board, const int previousMove, const int player) const
{
  qint64 now = QDateTime::currentMSecsSinceEpoch();
  qDebug() << "c: " << c << ", maxIterations: " << maxIterations << ", maxChildren: " <<maxChildren;
  Nodes nodes;
  nodes.reserve(maxIterations * maxChildren);
  nodes.append(Node { 0, 1, board, previousMove, -1, Node::Children() });

  int i;
  for(i = 0; i < maxIterations; ++i)
  {
    int leafIndex = select(nodes);
    Node const& leaf = nodes.at(leafIndex);

    GameState leafState = gameState(leaf.board, player);
    if(leafState == GameState::WIN)
    {
      qDebug() << "---";
      printBoard(leaf.board);

      break;
    }
    else if(leafState == GameState::LOSE)
    {
      backpropagate(leafIndex, nodes, -10);
    }
    else if(leafState == GameState::TIE)
    {
      backpropagate(leafIndex, nodes, -5);
    }
    else if(leafState == GameState::UNRESOLVED)
    {
      int nodeIndex = expand(leafIndex, nodes, player);

      Node const& node = nodes.at(nodeIndex);
      int score = simulate(node.board,  node.previousMove, player);

      backpropagate(nodeIndex, nodes, score);
    }
  }

  qDebug() << "Found solution in " << i + 1 << " iterations";
  Node const& root = nodes.at(0);
  int bestChildIndex = pickBestChild(root, nodes, false);
  Node const& bestChild = nodes.at(bestChildIndex);

  qDebug() << "AI took " << (QDateTime::currentMSecsSinceEpoch() - now) << " ms";

  for(int childIndex : root.children)
  {
    Node const& child = nodes.at(childIndex);
    qDebug() << child.previousMove << ":" << child.v << child.n;
  }
  return bestChild.previousMove;
}

int UltimateTicTacToeMontecarloAI::getMaxChildren() const
{
  return maxChildren;
}

void UltimateTicTacToeMontecarloAI::setMaxChildren(int value)
{
  if(value != maxChildren)
  {
    maxChildren = value;
    emit maxChildrenChanged(value);
  }
}

int UltimateTicTacToeMontecarloAI::getC() const
{
  return c;
}

void UltimateTicTacToeMontecarloAI::setC(int value)
{
  if(value != c)
  {
    c = value;
    emit cChanged(value);
  }
}

int UltimateTicTacToeMontecarloAI::getMaxIterations() const
{
  return maxIterations;
}

void UltimateTicTacToeMontecarloAI::setMaxIterations(int value)
{
  if(value != maxIterations)
  {
    maxIterations = value;
    emit maxIterationsChanged(value);
  }
}
