import QtQuick 2.3
import TimeModel 1.0

Item {
	id: host
	property ListModel catModel
	property TimeModel timeModel
	property TimeCalendar calendar
	property int itemSize

	signal doSave()

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

	TimeTableEdit {
		id: timeTable
		itemSize: host.itemSize
		catModel: host.catModel
		timeModel: host.timeModel
		anchors {
			top: calendarWidget.bottom
			left: host.left
			right: host.right
			bottom: saveButton.top
		}
	}

	Button {
		id: saveButton
		anchors {
			bottom: parent.bottom
			left: parent.left
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
			right: parent.right
		}
		text: "Today"
		itemSize: host.itemSize
		TimeCalendar {id:today}
		onClicked: {
			calendar.year = today.year
			calendar.month = today.month
			calendar.day = today.day
		}
	}
	Component.onCompleted: timeTable.scrollTo(calendar.time())
	Connections {
		target: calendar
		onDateChanged: timeTable.scrollTo(calendar.time())
	}
}
