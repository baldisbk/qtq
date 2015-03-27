import QtQuick 2.0


Item {
	id: host
	property int number
	property int current
	property int itemSize
	property int itemWidth
	property Component delegate
	property bool locked: false
	height: itemSize

	Button {
		id: leftBut
		anchors {
			top: parent.top
			left: parent.left
		}
		text: "<"
		itemSize: host.itemSize
		width: itemSize
		onClicked: list.decrementCurrentIndex()
	}

	Button {
		id: rightBut
		itemSize: host.itemSize
		width: itemSize
		anchors {
			top: parent.top
			right: parent.right
		}
		text: ">"
		onClicked: list.incrementCurrentIndex()
	}

	ListView {
		id: list
		anchors {
			left: leftBut.right
			right: rightBut.left
			top: parent.top
		}
		property int itemSize: host.itemSize
		property int oldX
		property int oldY

		function save() {
			oldX = contentX
			oldY = contentY
		}
		function restore(index) {
			contentX = oldX
			contentY = oldY
			currentIndex = index
		}

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
	function save() {
		list.save()
	}
	function restore(index) {
		list.restore(index)
	}

	onCurrentChanged: {
		if (list.currentIndex != current) {
			list.highlightMoveDuration = 0
			list.currentIndex = current
			list.positionViewAtIndex(current, ListView.Contain)
			list.highlightMoveDuration = -1
		}
	}
}
