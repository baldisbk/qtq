#ifndef TIMEMODEL_H
#define TIMEMODEL_H

#include <QAbstractItemModel>
#include <QQmlExtensionPlugin>
#include <QDate>

class TimeModel : public QAbstractItemModel
{
	Q_OBJECT
public:
	TimeModel();
	~TimeModel();

	enum Roles {
		TextRole = Qt::UserRole,
		ColorRole,
		TimeRole
	};

	// QAbstractItemModel interface
public:
	virtual QModelIndex index(int row, int column, const QModelIndex &parent) const;
	virtual QModelIndex parent(const QModelIndex &child) const;
	virtual int rowCount(const QModelIndex &parent) const;
	virtual int columnCount(const QModelIndex &parent) const;
	virtual QVariant data(const QModelIndex &index, int role) const;
	virtual QHash<int, QByteArray> roleNames() const;

public slots:
	void setTimeAttrs(int ind, int color, QString text);

private:
	QMap<int, int> mColors;
	QMap<int, QString> mTexts;
};

class TimeCalendar : public QObject {
	Q_OBJECT
public:
	TimeCalendar();

	Q_PROPERTY(int day READ getDay WRITE setDay NOTIFY dayChanged)
	Q_PROPERTY(int month READ getMonth WRITE setMonth NOTIFY monthChanged)
	Q_PROPERTY(int year READ getYear WRITE setYear NOTIFY yearChanged)

	Q_PROPERTY(int days READ getDays WRITE setDays NOTIFY daysChanged)
	Q_PROPERTY(int months READ getMonths CONSTANT)

	Q_INVOKABLE QString monthName(int m) const;
	Q_INVOKABLE bool isHoliday(int day, int month);
	Q_INVOKABLE bool isHoliday(int day);

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
private:
	QDate mDate;
};


//class TimeModelPlugin : public QQmlExtensionPlugin
//{
//    Q_OBJECT
//    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

//public:
//    void registerTypes(const char *uri)
//    {
//	Q_ASSERT(uri == QLatin1String("TimeExample"));
//	qmlRegisterType<TimeModel>(uri, 1, 0, "Time");
//    }
//};

#endif // TIMEMODEL_H
