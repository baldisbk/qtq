import QtQuick 2.0

Rectangle {
	property int itemSize
	width: itemSize
	height: itemSize
	color: "black"
	property int colorId: 0
	readonly property int maxCol: 15
	property bool invertTextColor: false
	property bool readOnly
	property alias text: textBox.text

	onColorIdChanged: {
		switch (colorId) {
		case 0: color = "black"; invertTextColor = true; break;
		case 1: color = "darkred"; invertTextColor = true; break;
		case 2: color = "purple"; invertTextColor = true; break;
		case 3: color = "darkblue"; invertTextColor = true; break;
		case 4: color = "darkcyan"; invertTextColor = false; break;
		case 5: color = "darkgreen"; invertTextColor = true; break;
		case 6: color = "brown"; invertTextColor = false; break;
		case 7: color = "gray"; invertTextColor = false; break;
		case 8: color = "red"; invertTextColor = false; break;
		case 9: color = "magenta"; invertTextColor = false; break;
		case 10: color = "blue"; invertTextColor = true; break;
		case 11: color = "cyan"; invertTextColor = false; break;
		case 12: color = "green"; invertTextColor = false; break;
		case 13: color = "yellow"; invertTextColor = false; break;
		case 14: color = "white"; invertTextColor = false; break;
		default: color = "darkgrey"; invertTextColor = true; break;
		}
	}

	Text {
		id: textBox
		anchors.centerIn: parent
		color: parent.invertTextColor ? "white" : "black"
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (!readOnly) {
				if (parent.colorId < parent.maxCol - 1)
					++parent.colorId;
				else
					parent.colorId = 0;
			}
		}
	}

	Behavior on color {
	       ColorAnimation { duration: 250 }
	}

}

