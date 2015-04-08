#ifndef TIMECALENDAR_H
#define TIMECALENDAR_H

#include <QObject>
#include <QDate>

class TimeCalendar : public QObject {
	Q_OBJECT
public:
	TimeCalendar();
	TimeCalendar(const TimeCalendar& c);
	TimeCalendar& operator=(const TimeCalendar& c);

	Q_PROPERTY(int day READ getDay WRITE setDay NOTIFY dayChanged)
	Q_PROPERTY(int month READ getMonth WRITE setMonth NOTIFY monthChanged)
	Q_PROPERTY(int year READ getYear WRITE setYear NOTIFY yearChanged)

	Q_PROPERTY(int days READ getDays WRITE setDays NOTIFY daysChanged)
	Q_PROPERTY(int months READ getMonths CONSTANT)

	Q_INVOKABLE QString monthName(int m) const;
	Q_INVOKABLE bool isHoliday(int day, int month);
	Q_INVOKABLE bool isHoliday(int day);

	Q_INVOKABLE QString string() const;
	Q_INVOKABLE int time() const;

	int getDays() const;
	int getMonths() const;

	int getDay() const;
	int getMonth() const;
	int getYear() const;

public slots:
	void setDay(int d);
	void setMonth(int m);
	void setYear(int y);

	void setDays(int) {}

signals:
	void dayChanged();
	void monthChanged();
	void yearChanged();
	void daysChanged();
	void monthsChanged();

	void dateChanged();

	void locked(bool lock);
private:
	QDate mDate;
};

#endif // TIMECALENDAR_H
