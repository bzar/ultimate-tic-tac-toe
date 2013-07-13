import QtQuick 2.0

Item {
  id: view

  signal select(int level)

  Column {
    id: buttons
    anchors.centerIn: parent
    spacing: view.height / 32

    Button {
      label: "Novice"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.select(0)
    }

    Button {
      label: "Beginner"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.select(1)
    }

    Button {
      label: "Intermediate"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.select(2)
    }

    Button {
      label: "Expert"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.select(3)
    }

    Button {
      label: "Insane"
      textColor: "#fff"
      color: "#ddd"
      font.pixelSize: height * 2 / 3
      width: view.width / 2
      height: view.height / 12
      radius: width / 32
      onClicked: view.select(4)
    }
  }
}
