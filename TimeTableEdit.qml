import QtQuick 2.0
import TimeModel 1.0

Item {
	id: host
	property int itemSize
	property ListModel catModel
	property TimeModel timeModel

	function scrollTo(index) {
		timeTable.positionViewAtIndex(index, ListView.Beginning)
	}

	CategorySelector {
		id: curCat
		theModel: catModel
		anchors.fill: parent
		itemSize: parent.itemSize
		z:1
	}

	ListView {
		id: timeTable
		model: timeModel
		delegate: TimeDelegate {
			anchors.left: parent.left
			anchors.right: parent.right
			itemSize: host.itemSize
			onItemClicked: timeModel.setTimeAttrs(
					index,
					curCat.currentItem.colorId,
					curCat.currentItem.text,
					curCat.currentItem.uid)
		}
		clip: true
		anchors {
			fill: parent
			topMargin: itemSize
		}
	}
}
