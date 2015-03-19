import QtQuick 2.0

Item {
	property string text: "here be dragonz"
	property int colorId: 10
	property bool readOnly: false
	property bool hasPlus: true
	property bool hasMinus: false
	property int itemSize

	property bool isComp: false

	height: itemSize

	signal insert()
	signal remove()
	signal changed()

	ColorRect {
		id: theNewColor
		colorId: parent.colorId
		anchors.left: parent.left
		anchors.top: parent.top
		readOnly: parent.readOnly
		onColorIdChanged: parent.colorId = colorId
		itemSize: parent.itemSize
	}
	TextInput {
		id: theNewText
		text: parent.text
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: theNewColor.right
		anchors.right: hasPlus ? plus.left : (hasMinus ? minus.left : parent.right)
		anchors.leftMargin: itemSize / 10
		readOnly: parent.readOnly

		onTextChanged: parent.text = text
	}
	Rectangle {
		id: plus
		color: "lightgray"
		radius: 10
		border.color: "black"
		border.width: 2
		height: itemSize
		width: itemSize
		anchors.right: hasMinus ? minus.left : parent.right
		anchors.verticalCenter: parent.verticalCenter
		visible: hasPlus
		Rectangle {
			width: itemSize * 2 / 3
			height: itemSize / 7
			radius: itemSize / 15
			anchors.centerIn: parent
			color: "green"
		}
		Rectangle {
			height: itemSize * 2 / 3
			width: itemSize / 7
			radius: itemSize / 15
			anchors.centerIn: parent
			color: "green"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: parent.parent.insert()
		}
	}
	Rectangle {
		id: minus
		color: "lightgray"
		radius: 10
		border.color: "black"
		border.width: 2
		height: itemSize
		width: itemSize
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		visible: hasMinus
		Rectangle {
			width: itemSize * 2 / 3
			height: itemSize / 7
			radius: itemSize / 15
			anchors.centerIn: parent
			color: "red"
		}

		MouseArea {
			anchors.fill: parent
			onClicked: parent.parent.remove()
		}
	}
	Component.onCompleted: {
		text = theNewText.text;
		colorId = theNewColor.colorId;
		isComp = true;
	}
	Connections {
		target: theNewText
		onEditingFinished: changed()
	}

	onColorIdChanged: if (isComp) changed()
}
