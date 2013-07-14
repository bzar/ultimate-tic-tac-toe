#ifndef ULTIMATETICTACTOEMONTECARLOAI_H
#define ULTIMATETICTACTOEMONTECARLOAI_H

#include <QObject>
#include <QVariantList>
#include <QList>

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
  int think(QVariantList board, int previousMove, int player);

private:
  int maxIterations = 1000;
  int c = 15;
  int maxChildren = 10;

  typedef QList<int> Board;
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

  int select(Nodes const& nodes, int const current = 0);
  int expand(int leafIndex, Nodes& nodes, const int player);
  int simulate(Board board, int const previousMove, int const player);
  void backpropagate(int const nodeIndex, Nodes& nodes, int const score);

  int scoreBoard(Board const& board, int const player);
  int scoreGrid(Board const& board, int const player, int const grid = 0);
  qreal nodeUCBValue(Node const& node, Nodes const& nodes);
  int pickBestChild(Node const& node, Nodes const& nodes, bool const ucb = true);
  Moves movementOptions(Board const& board, int const previousMove);
  Board playMove(Board board, Move const move, int const player);
  int otherPlayer(int const player);
  int gridWinner(Board const& board, int grid = 0);
  bool boardFull(Board const& board);
  GameState gameState(Board const& board, int player);

};

#endif // ULTIMATETICTACTOEMONTECARLOAI_H
