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
	readonly property int headerSize: 30
	property int itemSize: width / 10

	CategoriesModel {id: theCategories}
	TimeModel {id: timeModel}
	TimeCalendar {id: calendar}

	ObjectModel {
		id: thePages

		CategoryEditor {
			id: catEditor
			height: theMainView.height
			width: theMainView.width
			itemSize: mw.itemSize
			anchors.topMargin: headerSize
			theModel: theCategories
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
	}

	ListView {
		id: theMainView
		anchors { fill: parent; topMargin: headerSize }
		model: thePages
		preferredHighlightBegin: 0; preferredHighlightEnd: 0
		highlightRangeMode: ListView.StrictlyEnforceRange
		orientation: ListView.Horizontal
		snapMode: ListView.SnapOneItem
		flickDeceleration: 2000

		onCurrentItemChanged: theHeader.alterText(currentIndex)
	}

	ListModel {
		id: theHeaderModel
		ListElement {name: "Categories"}
		ListElement {name: "TimeTable"}
	}

	Text {
		id: theHeader
		height: headerSize
		anchors.left: parent.left
		anchors.right: parent.right
		function alterText(index) {
			text = theHeaderModel.get(index).name;
		}
	}

	// DB stuff ================

	property var db

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
			var rn = timeModel.rowNo()
			for (var i = 0; i < rn; ++i) {
				var uid = timeModel.uid(i);
				if (uid === -1)
					continue;
				db.transaction(function(tx){
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
				});
			}
		}
		onDoLoad: {
			db.transaction(function(tx){
				var rs = tx.executeSql(
					"SELECT time, catuid FROM Timetable "+
					"WHERE year=? AND month=? AND day=?",
					[ calendar.year, calendar.month, calendar.day ]);
				var rn = timeModel.rowNo()
				for(var i = 0; i < rn; ++i)
					timeModel.clearTimeAttrs(i)
				for(var i = 0; i < rs.rows.length; i++) {
					var cat = tx.executeSql(
						"SELECT name, color "+
						"FROM Categories "+
						"WHERE uid=?",
						[rs.rows.item(i).catuid] )
					timeModel.setTimeAttrs(
						rs.rows.item(i).time,
						cat.rows.item(0).color,
						cat.rows.item(0).name,
						rs.rows.item(i).catuid);
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
		});
		db.readTransaction(function(tx) {
			var rs = tx.executeSql('SELECT * FROM Categories');

			for(var i = 0; i < rs.rows.length; i++) {
				theCategories.addCategory(
					rs.rows.item(i).uid,
					rs.rows.item(i).name,
					rs.rows.item(i).color);
			}
		});
	}
}
