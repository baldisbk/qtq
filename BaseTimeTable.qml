import QtQuick 2.3
import TimeModel 1.0

Item {
	id: host
	property ListModel catModel
	property TimeModel timeModel
	property int itemSize

	signal doSave()

	TimeTableEdit {
		id: timeTable
		itemSize: host.itemSize
		catModel: host.catModel
		timeModel: host.timeModel
		anchors {
			fill: host
			bottomMargin: saveButton.height
		}
	}

	Button {
		id: saveButton
		anchors {
			bottom: parent.bottom
			left: parent.left
			right: parent.right
		}
		text: "Save"
		itemSize: host.itemSize
		width: parent.width/2
		onClicked: host.doSave()
	}
}
