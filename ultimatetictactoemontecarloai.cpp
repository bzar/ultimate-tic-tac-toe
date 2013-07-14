#include "ultimatetictactoemontecarloai.h"
#include <qmath.h>
#include <QDebug>
#include <QDateTime>

int const GRID_SIZE  = 9;
int const BOARD_SIZE  = GRID_SIZE * GRID_SIZE;

int UltimateTicTacToeMontecarloAI::scoreBoard(Board const& board, int const player)
{
  int score = 0;
  Board bigGrid;
  bigGrid.reserve(GRID_SIZE);
  for(int i = 0; i < GRID_SIZE; ++i)
  {
    score += scoreGrid(board, player, i);
    bigGrid.append(gridWinner(board, i));
  }

  score += 9 * scoreGrid(bigGrid, player);

  return score;
}

int UltimateTicTacToeMontecarloAI::scoreGrid(Board const& board, int const player, int const grid)
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
      int owner = board.at(GRID_SIZE * grid + lines[i][j]);
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

qreal UltimateTicTacToeMontecarloAI::nodeUCBValue(Node const& node, Nodes const& nodes) {
  if(node.parent != -1)
  {
    return node.v + c * qSqrt(qLn(nodes.at(node.parent).n) / node.n);
  } else {
    return 0;
  }
}

int UltimateTicTacToeMontecarloAI::pickBestChild(Node const& node, Nodes const& nodes, bool const ucb)
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

int UltimateTicTacToeMontecarloAI::select(Nodes const& nodes, int const current)
{
  Node const& node = nodes.at(current);
  if(node.children.empty())
    return current;

  return select(nodes, pickBestChild(node, nodes));
}

UltimateTicTacToeMontecarloAI::Moves UltimateTicTacToeMontecarloAI::movementOptions(Board const& board, int const previousMove)
{
  int grid = previousMove % GRID_SIZE;
  Moves options;
  options.reserve(9);

  for(int i = 0; i < GRID_SIZE; ++i)
  {
    int position = grid * GRID_SIZE + i;
    if(board.at(position) == 0)
    {
      options.append(position);
    }
  }

  if(options.empty())
  {
    for(int i = 0; i < BOARD_SIZE; ++i)
    {
      if(board.at(i) == 0)
      {
        options.append(i);
      }
    }
  }

  return options;
}

UltimateTicTacToeMontecarloAI::Board UltimateTicTacToeMontecarloAI::playMove(Board board, Move const move, int const player)
{
  board[move] = player;
  return board;
}

int UltimateTicTacToeMontecarloAI::otherPlayer(int const player)
{
  return player == 1 ? 2 : 1;
}

int UltimateTicTacToeMontecarloAI::expand(int leafIndex, Nodes& nodes, int const player)
{
  Node& node = nodes[leafIndex];
  node.children.reserve(maxChildren);
  Moves options = movementOptions(node.board, node.previousMove);
  int turn = otherPlayer(node.board.at(node.previousMove));

  int mostPromisingChildIndex = -1;
  int mostPromisingChildScore = 0;

  while(node.children.size() < maxChildren && !options.empty())
  {
    Move move = options.takeAt(qrand() % options.size());
    int childIndex = nodes.size();
    node.children.append(childIndex);
    nodes.append( Node {0, 1, playMove(node.board, move, turn), move, leafIndex, Node::Children()});
    int score = scoreBoard(nodes.last().board, player);
    if(score > mostPromisingChildScore || mostPromisingChildIndex < 0)
    {
      mostPromisingChildIndex = childIndex;
      mostPromisingChildScore = score;
    }
  }

  return mostPromisingChildIndex;
}

int UltimateTicTacToeMontecarloAI::gridWinner(Board const& board, int grid)
{
  int o = grid * GRID_SIZE;
  // rows
  if(board.at(o+0) != 0 && board.at(o+0) == board.at(o+1) && board.at(o+0) == board.at(o+2)) return board.at(o+0);
  if(board.at(o+3) != 0 && board.at(o+3) == board.at(o+4) && board.at(o+3) == board.at(o+5)) return board.at(o+3);
  if(board.at(o+6) != 0 && board.at(o+6) == board.at(o+7) && board.at(o+6) == board.at(o+8)) return board.at(o+6);

  // columns
  if(board.at(o+0) != 0 && board.at(o+0) == board.at(o+3) && board.at(o+0) == board.at(o+6)) return board.at(o+0);
  if(board.at(o+1) != 0 && board.at(o+1) == board.at(o+4) && board.at(o+1) == board.at(o+7)) return board.at(o+1);
  if(board.at(o+2) != 0 && board.at(o+2) == board.at(o+5) && board.at(o+2) == board.at(o+8)) return board.at(o+2);

  // diagonals
  if(board.at(o+0) != 0 && board.at(o+0) == board.at(o+4) && board.at(o+0) == board.at(o+8)) return board.at(o+0);
  if(board.at(o+6) != 0 && board.at(o+6) == board.at(o+4) && board.at(o+6) == board.at(o+2)) return board.at(o+6);

  return 0;
}

bool UltimateTicTacToeMontecarloAI::boardFull(Board const& board)
{
  for(int const& v : board)
  {
    if(v == 0)
    {
      return false;
    }
  }
  return true;
}

UltimateTicTacToeMontecarloAI::GameState UltimateTicTacToeMontecarloAI::gameState(Board const& board, int player)
{
  Board bigGrid;
  bigGrid.reserve(GRID_SIZE);
  for(int i = 0; i < GRID_SIZE; ++i)
  {
    bigGrid.append(gridWinner(board, i));
  }

  int winner = gridWinner(bigGrid);

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

int UltimateTicTacToeMontecarloAI::simulate(Board board, int const previousMove, int const player)
{
  int turn = otherPlayer(board.at(previousMove));
  GameState state = gameState(board, player);
  Move prev = previousMove;
  while(state == GameState::UNRESOLVED)
  {
    Moves options = movementOptions(board, prev);
    Move option = options.at(qrand() % options.size());
    board[option] = turn;
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

void UltimateTicTacToeMontecarloAI::backpropagate(int const nodeIndex, Nodes& nodes, int const score)
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
}

int UltimateTicTacToeMontecarloAI::think(QVariantList board, int previousMove, int player)
{
  qint64 now = QDateTime::currentMSecsSinceEpoch();
  qDebug() << "c: " << c << ", maxIterations: " << maxIterations << ", maxChildren: " <<maxChildren;
  Board b;
  b.reserve(BOARD_SIZE);
  for(int i = 0; i < BOARD_SIZE; ++i) {
    b.append(qvariant_cast<int>(board.at(i)));
  }

  Nodes nodes;
  nodes.reserve(maxIterations * maxChildren);
  nodes.append(Node { 0, 1, b, previousMove, -1, Node::Children() });

  int i;
  for(i = 0; i < maxIterations; ++i)
  {
    int leafIndex = select(nodes);
    Node const& leaf = nodes.at(leafIndex);

    GameState leafState = gameState(leaf.board, player);
    if(leafState != GameState::UNRESOLVED)
    {
      qDebug() << "---";
      for(int y = 0; y < 3; ++y)
      {
        for(int y2 = 0; y2 < 3; ++y2)
        {
          int o = y*3*GRID_SIZE + y2*3;
          qDebug() << leaf.board.at(o) << leaf.board.at(o+1) << leaf.board.at(o+2) << " "
                   << leaf.board.at(o+9)<< leaf.board.at(o+10)<< leaf.board.at(o+11) << " "
                   << leaf.board.at(o+18)<< leaf.board.at(o+19)<< leaf.board.at(o+20) << " ";
        }
        qDebug() << " ";
      }

      break;
    }
    int nodeIndex = expand(leafIndex, nodes, player);

    Node const& node = nodes.at(nodeIndex);
    int score = simulate(node.board,  node.previousMove, player);

    backpropagate(nodeIndex, nodes, score);
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
  emit result(bestChild.previousMove);
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
