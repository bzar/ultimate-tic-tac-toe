#ifndef ULTIMATETICTACTOEMONTECARLOAI_H
#define ULTIMATETICTACTOEMONTECARLOAI_H

#include <QObject>
#include <QVariantList>
#include <QList>
#include <QFutureWatcher>

class UltimateTicTacToeMontecarloAI : public QObject
{
  Q_OBJECT
public:
  explicit UltimateTicTacToeMontecarloAI(QObject *parent = 0);

  Q_PROPERTY(int maxIterations READ getMaxIterations WRITE setMaxIterations NOTIFY maxIterationsChanged)
  Q_PROPERTY(int c READ getC WRITE setC NOTIFY cChanged)
  Q_PROPERTY(int maxChildren READ getMaxChildren WRITE setMaxChildren NOTIFY maxChildrenChanged)

  int getMaxIterations() const;
  void setMaxIterations(int value);

  int getC() const;
  void setC(int value);

  int getMaxChildren() const;
  void setMaxChildren(int value);

signals:
  void result(int move);
  void maxIterationsChanged(int value);
  void cChanged(int value);
  void maxChildrenChanged(int value);

public slots:
  void think(QVariantList board, QVariantList bigGrid,int previousMove, int player);

private:
  int maxIterations = 1000;
  int c = 15;
  int maxChildren = 10;

  QFutureWatcher<int> futureWatcher;

  typedef QList<int> Grid;
  struct Board
  {
    Grid grids;
    Grid bigGrid;
  };

  typedef int Move;
  typedef QList<Move> Moves;

  enum class GameState { WIN, LOSE, TIE, UNRESOLVED };

  struct Node
  {
    typedef QList<int> Children;
    int v;
    int n;
    Board board;
    int previousMove;
    int parent;
    Children children;
  };

  typedef QList<Node> Nodes;

  int realThink(Board const& board, int const previousMove, int const player) const;
  int select(Nodes const& nodes, int const current = 0) const;
  int expand(int leafIndex, Nodes& nodes, const int player) const;
  int simulate(Board board, int const previousMove, int const player) const;
  void backpropagate(int const nodeIndex, Nodes& nodes, int const score) const;

  int scoreBoard(Board const& board, int const player) const;
  int scoreGrid(const Grid &grid, int const player, const int gridIndex = 0) const;
  qreal nodeUCBValue(Node const& node, Nodes const& nodes) const;
  int pickBestChild(Node const& node, Nodes const& nodes, bool const ucb = true) const;
  Moves movementOptions(Board const& board, int const previousMove) const;
  Board& playMove(Board& board, Move const move, int const player) const;
  int otherPlayer(int const player) const;
  int gridWinner(Grid const& grid, int gridIndex = 0) const;
  bool gridFull(Grid const& grid, int gridIndex = 0) const;
  bool boardFull(Board const& board) const;
  GameState gameState(Board const& board, int player) const;

  void printBoard(Board const& board) const;
};

#endif // ULTIMATETICTACTOEMONTECARLOAI_H
