#include "timecalendar.h"

#include "timemodel.h"

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

QString TimeCalendar::string() const
{
	return mDate.toString();
}

int TimeCalendar::time() const
{
	QTime cur = QDateTime::currentDateTime().time();
	int h = cur.hour();
	if (h < HOUR_MIN) h = HOUR_MIN;
	if (h > HOUR_MAX) h = HOUR_MAX;
	return h * HOUR_SPAN + cur.minute() * HOUR_SPAN / 60;
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
