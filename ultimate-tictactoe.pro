TARGET=ultimate-tictactoe

# Use C++11
CONFIG += c++11 sailfishapp

SOURCES += main.cpp \
    ultimatetictactoemontecarloai.cpp

OTHER_FILES += rpm/ultimate-tictactoe.spec \
    rpm/ultimate-tictactoe.yaml \
    ultimate-tictactoe.desktop \
    qml/DifficultySelectView.qml \
    qml/TicTacToeCell.qml \
    qml/Button.qml \
    qml/TicTacToeGrid.qml \
    qml/UltimateTicTacToeGrid.qml \
    qml/UltimateTicTacToeCell.qml \
    qml/cog.png \
    qml/TitleView.qml \
    qml/GameView.qml \
    qml/rules.js \
    qml/AITestView.qml \
    qml/main.qml \
    qml/cog.png

HEADERS += \
    ultimatetictactoemontecarloai.h
