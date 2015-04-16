import QtQuick 2.0
import TimeModel 1.0

Item {
	id: host
	property CategoriesModel catModel
	property TimeModel timeModel
	property TimeModel originModel
	property TimeCalendar calendar
	property int itemSize

	TimeStatModel {
		id: stat
		timeModel: host.timeModel
		originModel: host.originModel
	}

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

	ListView {
		id: timeTable
		model: stat
		delegate: Component {
			id: delegat
			Item {
				anchors.left: parent.left
				anchors.right: parent.right
				height: itemSize
				Text {
					id: timeText
					anchors.left: parent.left
					anchors.right: colorRect.left
					anchors.top: parent.top
					text: model.text
					height: itemSize
					verticalAlignment: Text.AlignVCenter
				}
				ColorRect {
					id: colorRect
					itemSize: host.itemSize
					colorId: model.colorId
					text: model.number
					readOnly: true
					anchors.right: parent.right
					anchors.top: parent.top
				}
			}
		}
		clip: true
		anchors {
			top: calendarWidget.bottom
			left: host.left
			right: host.right
			bottom: host.bottom
		}
	}
	Component.onCompleted: stat.recount()
	Connections {
		target: calendar
		onDateChanged: stat.recount()
	}
	Connections {
		target: catModel
		onAdded: stat.addCategory(uid, text, color)
	}
}

