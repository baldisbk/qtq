import QtQuick 2.0

Item {
	property bool templateOn: true

	Rectangle {
		id: theTemplate
		property bool onOff: parent.templateOn
		width: parent.width / 2
		height: parent.height
		anchors {
			left: parent.left
			verticalCenter: parent.verticalCenter
		}
		color: onOff ? "#FFFF88" : "white"
		Text {
			anchors.fill: parent
			text: "Template"
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
		MouseArea {
			anchors.fill: parent
			onClicked: switcher.templateOn = true
		}
	}
	Rectangle {
		id: theToday
		property bool onOff: !parent.templateOn
		width: parent.width / 2
		height: parent.height
		anchors {
			right: parent.right
			verticalCenter: parent.verticalCenter
		}
		color: onOff ? "#FFFF88" : "white"
		MouseArea {
			anchors.fill: parent
			onClicked: switcher.templateOn = false
		}
		Text {
			anchors.fill: parent
			text: "Today"
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
}
