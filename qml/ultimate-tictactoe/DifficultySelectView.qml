import QtQuick 2.0

Item {
  id: view

  signal select(int level)

  Column {
    id: buttons
    anchors.centerIn: parent
    spacing: view.height / 32

    Button {
      label.text: "Novice"
      width: view.width / 2
      height: view.height / 12
      onClicked: view.select(0)
    }

    Button {
      label.text: "Beginner"
      width: view.width / 2
      height: view.height / 12
      onClicked: view.select(1)
    }

    Button {
      label.text: "Intermediate"
      width: view.width / 2
      height: view.height / 12
      onClicked: view.select(2)
    }

    Button {
      label.text: "Expert"
      width: view.width / 2
      height: view.height / 12
      onClicked: view.select(3)
    }

    Button {
      label.text: "Insane"
      width: view.width / 2
      height: view.height / 12
      onClicked: view.select(4)
    }
  }
}
