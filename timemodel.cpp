#include "timemodel.h"

#include <QColor>

#include <QDebug>

#define HOUR_MIN 0
#define HOUR_MAX 23
#define HOUR_SPAN 4

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

int TimeModel::rowNo() const
{
	return rowCount(QModelIndex());
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


TimeCalendar::TimeCalendar()
{
	connect(this, SIGNAL(dayChanged()), SIGNAL(dateChanged()));
	connect(this, SIGNAL(monthChanged()), SIGNAL(dateChanged()));
	connect(this, SIGNAL(yearChanged()), SIGNAL(dateChanged()));
	mDate = QDate::currentDate();
}

TimeCalendar::TimeCalendar(const TimeCalendar &c): QObject(c.parent())
{
	*this = c;
}

TimeCalendar &TimeCalendar::operator=(const TimeCalendar &c)
{
	setYear(c.getYear());
	setMonth(c.getMonth());
	setDay(c.getDay());
	return *this;
}

QString TimeCalendar::monthName(int m) const
{
	switch (m) {
	case 0: return tr("January");
	case 1: return tr("February");
	case 2: return tr("March");
	case 3: return tr("April");
	case 4: return tr("May");
	case 5: return tr("June");
	case 6: return tr("July");
	case 7: return tr("August");
	case 8: return tr("September");
	case 9: return tr("October");
	case 10: return tr("November");
	case 11: return tr("December");
	}
	return QString();
}

bool TimeCalendar::isHoliday(int day, int month)
{
	return QDate(getYear(), month + 1, day + 1).dayOfWeek() >= 6;
}

bool TimeCalendar::isHoliday(int day)
{
	return QDate(getYear(), getMonth() + 1, day + 1).dayOfWeek() >= 6;
}

TimeCalendar TimeCalendar::today() const
{
	return TimeCalendar();
}

QString TimeCalendar::string() const
{
	return mDate.toString();
}

int TimeCalendar::getDays() const
{
	return mDate.daysInMonth();
}

int TimeCalendar::getMonths() const
{
	return 12;
}

int TimeCalendar::getDay() const
{
	return mDate.day() - 1;
}

int TimeCalendar::getMonth() const
{
	return mDate.month() - 1;
}

int TimeCalendar::getYear() const
{
	return mDate.year();
}

void TimeCalendar::setDay(int d)
{
	if (d<0 || d>=getDays())
		return;
	int oldd = getDay();
	mDate.setDate(mDate.year(), mDate.month(), d+1);
	if (d != oldd) emit dayChanged();
}

void TimeCalendar::setMonth(int m)
{
	if (m<0 || m>=getMonths())
		return;
	int oldm = getMonth();
	int oldds = getDays();
	int oldd = getDay();
	int newd = oldd;
	mDate.setDate(mDate.year(), m+1, 1);
	if (newd >= getDays())
		newd = getDays() - 1;
	mDate.setDate(mDate.year(), m+1, newd + 1);
	emit locked(true);
	if (getDays() != oldds) emit daysChanged();
	emit locked(false);
	if (oldd != newd) emit dayChanged();
	if (m != oldm) emit monthChanged();
}

void TimeCalendar::setYear(int y)
{
	int oldy = getYear();
	int oldds = getDays();
	int oldd = getDay();
	int newd = oldd;
	mDate.setDate(y, mDate.month(), 1);
	if (newd >= getDays())
		newd = getDays() - 1;
	mDate.setDate(y, mDate.month(), newd + 1);
	emit locked(true);
	if (getDays() != oldds) emit daysChanged();
	emit locked(false);
	if (oldd != newd) emit dayChanged();
	if (y != oldy) emit yearChanged();
}
