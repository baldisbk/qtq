import QtQuick 2.0


Item {
	id: host
	property int number
	property int current
	property int itemSize
	property int itemWidth
	property Component delegate
	height: itemSize

	Rectangle {
		id: leftBut
		height: itemSize
		width: itemSize
		border.color: "black"
		radius: 10
		anchors {
			top: parent.top
			left: parent.left
		}
		Text {
			anchors.centerIn: parent
			text: "<"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: list.decrementCurrentIndex()
		}
	}

	Rectangle {
		id: rightBut
		height: itemSize
		width: itemSize
		border.color: "black"
		radius: 10
		anchors {
			top: parent.top
			right: parent.right
		}
		Text {
			anchors.centerIn: parent
			text: ">"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: list.incrementCurrentIndex()
		}
	}

	ListView {
		id: list
		anchors {
			left: leftBut.right
			right: rightBut.left
			top: parent.top
		}
		property int itemSize: host.itemSize
		height: itemSize

		model: host.number
		delegate: host.delegate

		clip: true
		orientation: ListView.Horizontal

		highlight: Rectangle {
			color: "#FFFF88"
			radius: 10
		}

		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightFollowsCurrentItem: true
		preferredHighlightBegin: 0
		preferredHighlightEnd: width

		snapMode: ListView.SnapToItem

		Component.onCompleted: {
			currentIndex = host.current
			positionViewAtIndex(currentIndex, ListView.Contain)
		}
		onCurrentIndexChanged: if (host.current != currentIndex) host.current = currentIndex
	}
	onCurrentChanged: {
		console.log("c0", list.currentIndex, current)
		if (list.currentIndex != current) {
			//var cur = current
			list.highlightMoveDuration = 0
			list.currentIndex = current
			list.positionViewAtIndex(current, ListView.Contain)
			list.highlightMoveDuration = -1
		}
	}
}
