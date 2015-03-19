import QtQuick 2.0

Rectangle {
	property int itemSize
	width: itemSize
	height: itemSize
	color: "black"
	property int colorId: 0
	readonly property int maxCol: 15
	property bool readOnly

	onColorIdChanged: {
		switch (colorId) {
		case 0: color = "black"; break;
		case 1: color = "darkred"; break;
		case 2: color = "purple"; break;
		case 3: color = "darkblue"; break;
		case 4: color = "darkcyan"; break;
		case 5: color = "green"; break;
		case 6: color = "brown"; break;
		case 7: color = "gray"; break;
		case 8: color = "red"; break;
		case 9: color = "magenta"; break;
		case 10: color = "blue"; break;
		case 11: color = "cyan"; break;
		case 12: color = "green"; break;
		case 13: color = "yellow"; break;
		case 14: color = "white"; break;
		default: color = "darkgrey"; break;
		}
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

