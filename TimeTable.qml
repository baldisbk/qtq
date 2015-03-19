import QtQuick 2.3
import TimeModel 1.0

Item {
	id: host
	property ListModel catModel
	property TimeModel timeModel
	property int itemSize

	CategorySelector {
		id: curCat
		theModel: catModel
		anchors.fill: parent
		itemSize: parent.itemSize
		z:1
	}

	Switcher {
		id: switcher
		height: itemSize
		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			topMargin: itemSize
		}
	}

	ListView {
		model: timeModel
		delegate: TimeDelegate {
			anchors.left: parent.left
			anchors.right: parent.right
			itemSize: host.itemSize
			onItemClicked: timeModel.setTimeAttrs(
					index,
					curCat.currentItem.colorId,
					curCat.currentItem.text)
		}
		clip: true
		anchors {
			bottom: parent.bottom
			left: parent.left
			right: parent.right
			top: switcher.bottom
		}
	}
}
