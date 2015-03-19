import QtQuick 2.0

Item {
	id: host
	property ListModel theModel
	property int itemSize
	Component {
		id: theDelegate
		ColorLine {
			id: theContents
			text: category
			colorId: model.colorId
			readOnly: false
			hasMinus: true
			hasPlus: false
			itemSize: host.itemSize
			anchors.left: parent.left
			anchors.right: parent.right
			onRemove: theModel.removeCategory(index)
			onChanged: theModel.changeCategory(model.uid, text, colorId)

			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: theContents; property: "itemSize"; value: 0 }
				NumberAnimation { target: theContents; property: "itemSize"; to: host.itemSize; duration: 250; easing.type: Easing.InOutQuad }
			}

			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: theContents; property: "ListView.delayRemove"; value: true }
				NumberAnimation { target: theContents; property: "itemSize"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: theContents; property: "ListView.delayRemove"; value: false }
			}
		}
	}

	ListView {
		id: theView
		model: theModel
		delegate: theDelegate
		anchors.bottom: theLine.top
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		clip: true
	}

	ColorLine {
		id: theLine
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		itemSize: parent.itemSize
		onInsert: theModel.addCategory(-1, text, colorId);
	}
}

