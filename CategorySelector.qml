import QtQuick 2.0

Item {
	id: host
	property ListModel theModel
	property Item currentItem: listView.currentItem
	property int itemSize
	Component {
		id: theDelegate
		ColorLine {
			property int uid: model.uid

			text: category
			colorId: model.colorId

			readOnly: true
			hasMinus: false
			hasPlus: false
			anchors.left: parent.left
			anchors.right: parent.right
			itemSize: host.itemSize

			MouseArea {
				anchors.fill: parent
				onClicked: {
					listView.isPressed = !listView.isPressed
					listView.contentY = index * itemSize
				}
			//	onPressed: listView.isPressed = true
			//	onReleased: listView.isPressed = false
			}
		}
	}

	ListView {
		Rectangle {z: -1; anchors.fill: parent; color: "white"}

		id: listView
		model: theModel
		delegate: theDelegate
		z: 1

		property int minTopMarg: 0
		property int maxBottomMarg: 0
		property int defSize: itemSize
		property int defPos: 0
		property real expansion: 0.0
		property bool isPressed: true

		clip: true
		highlightFollowsCurrentItem: true
		snapMode: ListView.SnapToItem
		highlight: Rectangle {color: "#FFFF88"}
		highlightRangeMode: ListView.StrictlyEnforceRange

		preferredHighlightBegin: defPos*expansion
		preferredHighlightEnd: defPos*expansion + defSize

		anchors {
			fill: parent
			topMargin: defPos*(1-expansion) + minTopMarg*expansion
			bottomMargin: (parent.height-defPos-defSize)*(1-expansion) + maxBottomMarg*expansion
		}

		Behavior on expansion {
			NumberAnimation {
				duration: 500
				easing.type: Easing.InOutQuad
			}
		}

		onIsPressedChanged: expansion = isPressed ? 1 : 0

		onFlickEnded: isPressed = false
		onMovementEnded: isPressed = false
	}
}
