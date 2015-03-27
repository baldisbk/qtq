import QtQuick 2.0

Item {
	property int itemSize
	height: timeColor.height
	signal itemClicked(int index)
	Text {
		id: timeText
		anchors.left: parent.left
		anchors.top: parent.top
		text: model.time
		height: itemSize
		width: itemSize * 2
		verticalAlignment: Text.AlignVCenter
	}
	ColorRect {
		id: timeColor
		itemSize: parent.itemSize
		colorId: model.colorId
		readOnly: true
		anchors.left: timeText.right
		anchors.top: parent.top
	}
	Text {
		id: catText
		anchors.left: timeColor.right
		anchors.right: parent.right
		anchors.top: parent.top
		text: model.text
		verticalAlignment: Text.AlignVCenter
		height: itemSize
	}
	MouseArea {
		anchors.fill: parent
		onClicked: parent.itemClicked(index)
	}
}
