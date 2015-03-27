import QtQuick 2.0
import TimeModel 1.0

Item {
	id: host
	property TimeCalendar date
	function output(text) {
		console.log(
			text,
			"date",
				date.day,
				date.month,
				date.year,
			"list",
				day.current,
				month.current);
	}
	property int itemSize

	height: month.height + day.height

	CalengarItem {
		id: month
		itemSize: host.itemSize
		itemWidth: host.itemSize * 4
		number: date.months
		delegate: Component {
			Item {
				anchors {
					top: parent.top
					bottom: parent.bottom
				}
				height: month.itemSize
				width: month.itemWidth
				Text {
					text: date.monthName(index)
					anchors.centerIn: parent
				}
				Rectangle {
					anchors.fill: parent
					border.color: "black"
					color: "#00000000"
					radius: 10
				}
			}
		}
		anchors {
			top: host.top
			left: host.left
			right: host.right
		}
		onCurrentChanged: {
			if (!locked && date.month != current)
				date.month = current
		}
		Component.onCompleted: current = date.month
		Connections {
			target: date
			onLocked: month.locked = lock
			onMonthChanged: month.current = date.month
		}
	}


	CalengarItem {
		id: day
		itemSize: host.itemSize
		itemWidth: host.itemSize
		number: date.days
		delegate: Component {
			id: dayDelegate
			Item {
				anchors {
					top: parent.top
					bottom: parent.bottom
				}
				height: day.itemSize
				width: day.itemWidth
				Text {
					text: index + 1
					anchors.centerIn: parent
					color: if (date.isHoliday(index)) return "red"; else return "black"
				}
				Rectangle {
					anchors.fill: parent
					border.color: "black"
					color: "#00000000"
					radius: 10
				}
				MouseArea {
					anchors.fill: parent
					onClicked: parent.ListView.view.currentIndex = index
				}
			}
		}
		anchors {
			top: month.bottom
			left: host.left
			right: host.right
		}
		onCurrentChanged: {
			if (!locked && date.day != current)
				date.day = current
		}
		Component.onCompleted: current = date.day
		Connections {
			target: date
			onLocked: {
				day.locked = lock
				if (lock)
					day.save()
				else
					day.restore(date.day)
			}
			onDayChanged: day.current = date.day
			onDaysChanged: day.current = date.day
		}
	}
}
