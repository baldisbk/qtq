#include "timemodel.h"

#include <QColor>

#include <QDebug>

TimeModel::TimeModel()
{
	for (int i = 0; i < rowCount(QModelIndex()); ++i)
		mColors[i] = -1;
}

TimeModel::~TimeModel()
{
}

QModelIndex TimeModel::index(int row, int column, const QModelIndex &parent) const
{
	if (parent.isValid())
		return QModelIndex();
	return createIndex(row, column);
}

QModelIndex TimeModel::parent(const QModelIndex &) const
{
	return QModelIndex();
}

int TimeModel::rowCount(const QModelIndex &) const
{
	return (HOUR_MAX-HOUR_MIN+1)*HOUR_SPAN;
}

int TimeModel::columnCount(const QModelIndex &) const
{
	return 1;
}

QVariant TimeModel::data(const QModelIndex &index, int role) const
{
	switch (role) {
	case Qt::DisplayRole:
	case Qt::EditRole:
	case TimeRole:
		return QString("%1:%2").
			arg(index.row()/HOUR_SPAN).
			arg((index.row()%HOUR_SPAN)*(60/HOUR_SPAN), 2, 10, QChar('0'));
	case TextRole:
		return mTexts.value(index.row(), QString());
	case ColorRole:
		return mColors.value(index.row(), -1);
	case UidRole:
		return mUids.value(index.row(), -1);
	case Qt::DecorationRole:
		switch (mColors.value(index.row(), -1)) {
		case 0: return QColor(Qt::black);
		case 1: return QColor(Qt::darkRed);
		case 2: return QColor(Qt::darkMagenta);
		case 3: return QColor(Qt::darkBlue);
		case 4: return QColor(Qt::darkCyan);
		case 5: return QColor(Qt::darkGreen);
		case 6: return QColor(Qt::darkYellow);
		case 7: return QColor(Qt::gray);
		case 8: return QColor(Qt::red);
		case 9: return QColor(Qt::magenta);
		case 10: return QColor(Qt::blue);
		case 11: return QColor(Qt::cyan);
		case 12: return QColor(Qt::green);
		case 13: return QColor(Qt::yellow);
		case 14: return QColor(Qt::white);
		default: return QColor(Qt::darkGray);
		}
	}
	return QVariant();
}

QHash<int, QByteArray> TimeModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles.insert(TextRole, "text");
	roles.insert(ColorRole, "colorId");
	roles.insert(TimeRole, "time");
	roles.insert(UidRole, "uid");
	return roles;
}

int TimeModel::uid(int ind) const
{
	return mUids.value(ind, -1);
}

void TimeModel::setTimeAttrs(int ind, int color, QString text, int uid)
{
	QModelIndex i = index(ind, 0, QModelIndex());
	mColors[i.row()] = color;
	mTexts[i.row()] = text;
	mUids[i.row()] = uid;
	emit dataChanged(i, i);
}

void TimeModel::clearTimeAttrs(int ind)
{
	QModelIndex i = index(ind, 0, QModelIndex());
	mColors.remove(i.row());
	mTexts.remove(i.row());
	mUids.remove(i.row());
	emit dataChanged(i, i);
}
