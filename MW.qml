import QtQuick 2.2
import QtQuick.Window 2.1
import QtQml.Models 2.1
import QtQuick.LocalStorage 2.0
import TimeModel 1.0

Window {
	id: mw
	visible: true
	height: 500
	width: 300
	property int itemSize: width / 6

	CategoriesModel {id: theCategories}
	TimeModel {id: timeModel}
	TimeModel {id: baseTimeModel}
	TimeCalendar {id: calendar}

	ObjectModel {
		id: thePages
		StatTable {
			height: theMainView.height
			width: theMainView.width
			itemSize: mw.itemSize
			anchors.topMargin: itemSize

			catModel: theCategories
			timeModel: timeModel
			originModel: baseTimeModel
			calendar: calendar
		}
		TimeTable {
			id: timeTable
			height: theMainView.height
			width: theMainView.width
			itemSize: mw.itemSize
			catModel: theCategories
			timeModel: timeModel
			calendar: calendar
		}
		BaseTimeTable {
			id: baseTable
			height: theMainView.height
			width: theMainView.width
			itemSize: mw.itemSize
			catModel: theCategories
			timeModel: baseTimeModel
		}
		CategoryEditor {
			id: catEditor
			height: theMainView.height
			width: theMainView.width
			itemSize: mw.itemSize
			anchors.topMargin: itemSize
			theModel: theCategories
		}
	}

	ListView {
		id: theMainView
		anchors { fill: parent; topMargin: itemSize }
		model: thePages
		preferredHighlightBegin: 0; preferredHighlightEnd: 0
		highlightRangeMode: ListView.StrictlyEnforceRange
		orientation: ListView.Horizontal
		snapMode: ListView.SnapOneItem
		flickDeceleration: 2000

		onCurrentItemChanged: theHeader.alterText(currentIndex)
		Component.onCompleted: currentIndex = 1
	}

	ListModel {
		id: theHeaderModel
		ListElement {name: "Stat"}
		ListElement {name: "Timetable"}
		ListElement {name: "Origin"}
		ListElement {name: "Categories"}
	}

	Text {
		id: theHeader
		height: itemSize
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		verticalAlignment: Text.AlignVCenter
		function alterText(index) {
			text = theHeaderModel.get(index).name;
		}
	}

	// DB stuff ================

	property var db

	function loadTimeModel() {
		db.transaction(function(tx){
			var rs = tx.executeSql(
				"SELECT time, catuid FROM Timetable "+
				"WHERE year=? AND month=? AND day=?",
				[ calendar.year, calendar.month, calendar.day ]);
			var rn = timeModel.count
			var i
			for(i = 0; i < rn; ++i)
				timeModel.clearTimeAttrs(i)
			for(i = 0; i < rs.rows.length; i++) {
				timeModel.setTimeAttrs(
					rs.rows.item(i).time,
					theCategories.catColor(rs.rows.item(i).catuid),
					theCategories.catText(rs.rows.item(i).catuid),
					rs.rows.item(i).catuid);
			}
		});
	}

	Connections {
		target: theCategories
		onAdded: {
			var txt = text;
			var col = color;
			var ident = uid;
			db.transaction(function(tx){
				if (ident != -1)
					return;
				var rs = tx.executeSql(
					'SELECT uid FROM Categories WHERE name=? AND color=?',
					[txt, col]);
				if (rs.rows.length != 0) {
					theCategories.setId(-1);
					return;
				}
				tx.executeSql(
					'INSERT INTO Categories(name, color) VALUES(?, ?)',
					[txt, col]);
				rs = tx.executeSql(
					'SELECT uid FROM Categories WHERE name=? AND color=?',
					[txt, col]);
				theCategories.setId(rs.rows.item(0).uid);
			});
		}
		onRemoved: {
			var uident = uid;
			db.transaction(function(tx){
				tx.executeSql("DELETE FROM Categories WHERE uid=?", [ uident ]);
			});
		}
		onChanged: {
			var txt = text;
			var col = color;
			var ident = uid;
			db.transaction(function(tx){
				tx.executeSql(
					"UPDATE Categories SET name=?, color=? WHERE uid=?",
					[ txt, col, ident ]);
			});
		}
	}
	Connections {
		target: timeTable
		onDoSave: {
			var rn = timeModel.count
			db.transaction(function(tx){
				tx.executeSql(
					"DELETE FROM Timetable WHERE "+
						"year = ? AND "+
						"month = ? AND "+
						"day = ?",
					[calendar.year, calendar.month, calendar.day])
				for (var i = 0; i < rn; ++i) {
					var uid = timeModel.uid(i);
					if (uid === -1)
						continue;
					tx.executeSql(
						"INSERT INTO Timetable("+
							"year, month, day, "+
							"time, catuid) "+
							"VALUES(?, ?, ?, ?, ?)",
						[
							calendar.year,
							calendar.month,
							calendar.day,
							i, uid ]);
				}
			});
		}
	}
	Connections {
		target: calendar
		onDateChanged: loadTimeModel()
	}

	Connections {
		target: baseTable
		onDoSave: {
			var rn = baseTimeModel.count
			db.transaction(function(tx){
				tx.executeSql("DELETE FROM BaseTimetable", [])
				for (var i = 0; i < rn; ++i) {
					var uid = baseTimeModel.uid(i);
					if (uid === -1)
						continue;
					tx.executeSql(
						"INSERT INTO BaseTimetable("+
							"time, catuid) "+
							"VALUES(?, ?)",
						[ i, uid ]);
				}
			});
		}
	}

	Component.onCompleted: {
		db = LocalStorage.openDatabaseSync("ExampleDB", "1.0", "", 0);

		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE Categories');
			tx.executeSql(
				'CREATE TABLE IF NOT EXISTS Categories('+
					'uid INTEGER PRIMARY KEY AUTOINCREMENT,'+
					'name TEXT,'+
					'color INTEGER)');
			tx.executeSql(
				'CREATE TABLE IF NOT EXISTS Timetable('+
					'uid INTEGER PRIMARY KEY AUTOINCREMENT,'+
					'year INTEGER,'+
					'month INTEGER,'+
					'day INTEGER,'+
					'time INTEGER,'+
					'catuid INTEGER)');
			tx.executeSql(
				'CREATE TABLE IF NOT EXISTS BaseTimetable('+
					'uid INTEGER PRIMARY KEY AUTOINCREMENT,'+
					'time INTEGER,'+
					'catuid INTEGER)');
		});
		db.readTransaction(function(tx) {
			var rs = tx.executeSql('SELECT * FROM Categories');

			for(var i = 0; i < rs.rows.length; i++) {
				theCategories.addCategory(
					rs.rows.item(i).uid,
					rs.rows.item(i).name,
					rs.rows.item(i).color);
			}

			var rs2 = tx.executeSql(
				"SELECT time, catuid FROM BaseTimetable", [ ]);
			var rn = baseTimeModel.count
			for(var i = 0; i < rn; ++i)
				baseTimeModel.clearTimeAttrs(i)
			for(var i = 0; i < rs2.rows.length; i++) {
				baseTimeModel.setTimeAttrs(
					rs2.rows.item(i).time,
					theCategories.catColor(rs2.rows.item(i).catuid),
					theCategories.catText(rs2.rows.item(i).catuid),
					rs2.rows.item(i).catuid);
			}
		});
		loadTimeModel()
	}
}
