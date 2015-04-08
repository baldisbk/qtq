#ifndef TIMEMODEL_H
#define TIMEMODEL_H

#include <QAbstractItemModel>
#include <QQmlExtensionPlugin>

#define HOUR_MIN 0
#define HOUR_MAX 23
#define HOUR_SPAN 4

class TimeModel : public QAbstractItemModel
{
	Q_OBJECT
public:
	TimeModel();
	~TimeModel();

	enum Roles {
		TextRole = Qt::UserRole,
		ColorRole,
		TimeRole,
		UidRole
	};

	// QAbstractItemModel interface
public:
	virtual QModelIndex index(int row, int column, const QModelIndex &parent) const;
	virtual QModelIndex parent(const QModelIndex &child) const;
	virtual int rowCount(const QModelIndex &parent) const;
	virtual int columnCount(const QModelIndex &parent) const;
	virtual QVariant data(const QModelIndex &index, int role) const;
	virtual QHash<int, QByteArray> roleNames() const;

	Q_INVOKABLE int rowNo() const;
	Q_INVOKABLE int uid(int ind) const;

public slots:
	void setTimeAttrs(int ind, int color, QString text, int uid);
	void clearTimeAttrs(int ind);

private:
	QMap<int, int> mColors;
	QMap<int, QString> mTexts;
	QMap<int, int> mUids;
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
