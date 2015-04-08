import QtQuick 2.0

ListModel {
	property int lastAdded: 0
	signal added(int uid, string text, int color)
	signal removed(int uid)
	signal changed(int uid, string text, int color)
	function addCategory(uid, text, col) {
		lastAdded = count
		append({"uid": uid, "category": text, "colorId": col});
		added(uid, text, col);
	}
	function removeCategory(ind) {
		removed(get(ind).uid);
		remove(ind);
	}
	function setId(uid) {
		if (uid === -1)
			remove(lastAdded);
		else
			get(lastAdded).uid = uid;
	}
	function changeCategory(uid, text, col) {
		var i;
		for (i=0; i<count; ++i)
			if (get(i).uid === uid) {
				get(i).text = text;
				get(i).colorId = col;
				changed(uid, text, col);
				return;
			}
	}
	function catText(uid) {
		var i;
		for (i=0; i<count; ++i)
			if (get(i).uid === uid)
				return get(i).category
		return ""
	}
	function catColor(uid) {
		var i;
		for (i=0; i<count; ++i)
			if (get(i).uid === uid)
				return get(i).colorId
		return ""
	}
}
