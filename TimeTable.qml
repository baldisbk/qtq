import QtQuick 2.3
import TimeModel 1.0

Item {
	id: host
	property ListModel catModel
	property TimeModel timeModel
	property TimeCalendar calendar
	property int itemSize

//	Switcher {
//		id: switcher
//		height: itemSize
//		anchors {
//			left: parent.left
//			right: parent.right
//			top: host.top
//			topMargin: itemSize
//		}
//	}
	signal doSave()
	signal doLoad()

	Calendar {
		id: calendarWidget
		date: calendar
		width: parent.width
		itemSize: host.itemSize
		anchors {
			top: host.top
			left: host.left
			right: host.right
		}
	}

	CategorySelector {
		id: curCat
		theModel: catModel
		anchors {
			top: calendarWidget.bottom
			left: host.left
			right: host.right
			bottom: host.bottom
		}
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
			bottom: parent.bottom
			left: parent.left
			right: parent.right
			top: calendarWidget.bottom
			topMargin: itemSize
			bottomMargin: itemSize
		}
	}
	Button {
		id: saveButton
		anchors {
			bottom: parent.bottom
				left: parent.left
//				right: parent.right
		}
		text: "Save"
		itemSize: host.itemSize
		width: parent.width/2
		onClicked: host.doSave()
	}
	Button {
		id: todayButton
		width: parent.width/2
		anchors {
			bottom: parent.bottom
//				left: parent.left
				right: parent.right
		}
		text: "Today"
		itemSize: host.itemSize
		onClicked: host.doSave()
	}
	Component.onCompleted: doLoad()
	Connections {
		target: calendar
		onDateChanged: doLoad()
	}
	onDoLoad: timeTable.positionViewAtIndex(
			calendar.time(),
			ListView.Beginning)
}
