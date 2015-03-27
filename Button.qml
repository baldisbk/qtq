import QtQuick 2.0

Rectangle {
	id: host
	property string text
	property int itemSize
	signal clicked()
	height: itemSize

	Rectangle {
		id: bord
		anchors.fill: parent
		anchors.margins: shift
		property int shift: 0
		radius: 10
		border.color: "black"
	}
	Text {
		text: host.text
		anchors.centerIn: host
	}
	MouseArea {
		id: mouseArea
		anchors.fill: host
		onClicked: host.clicked()
	}

	states: State {
		name: "pressed"
		when: mouseArea.pressed
		PropertyChanges { target: bord; color: "#FFFF88"; shift: 10 }
	}

	transitions: Transition {
		ParallelAnimation {
			PropertyAnimation { property: "shift"; duration: 100 }
			ColorAnimation { duration: 100 }
		}
	}
}
