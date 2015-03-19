import QtQuick 2.0
import TimeModel 1.0

Item {
	id: host
	property TimeCalendar date: TimeCalendar {
		onDateChanged: {
			console.log(date.day, date.month, date.year);
		}
	}
	property int itemSize

	CalengarItem {
		id: month
		itemSize: host.itemSize
		itemWidth: host.itemSize * 8
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
		current: date.month
		onCurrentChanged: {
			var d = date.day
			date.month = current
			console.log("day", d, date.days)
			if (d >= date.days)
				d = 1
			day.current = d
		}
	}


	CalengarItem {
		id: day
		itemSize: host.itemSize
		itemWidth: host.itemSize
		number: date.days
		delegate: Component {
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
					color: if (date.isHoliday(index+1)) return "red"; else return "black"
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
			top: month.bottom
			left: host.left
			right: host.right
		}
		current: date.day
		onCurrentChanged: {
			date.day = current
		}
	}
}
