#ifndef TIMESTATMODEL_H
#define TIMESTATMODEL_H

#include <QAbstractItemModel>

class TimeModel;

class TimeStatModel : public QAbstractItemModel
{
	Q_OBJECT
public:
	TimeStatModel(QObject* parent = NULL);
	~TimeStatModel();

	enum Roles {
		TextRole = Qt::UserRole,
		ColorRole,
		NumberRole
	};

	enum Rows {
		Precision = 0,
		Quantity,
		numberOfBaseRows
	};

public:
	virtual QModelIndex index(int row, int column, const QModelIndex &parent) const;
	virtual QModelIndex parent(const QModelIndex &child) const;
	virtual int rowCount(const QModelIndex &parent) const;
	virtual int columnCount(const QModelIndex &parent) const;
	virtual QVariant data(const QModelIndex &index, int role) const;
	virtual QHash<int, QByteArray> roleNames() const;

	Q_PROPERTY(TimeModel* timeModel READ timeModel WRITE setTimeModel NOTIFY timeModelChanged)
	Q_PROPERTY(TimeModel* originModel READ originModel WRITE setOriginModel NOTIFY originModelChanged)

	TimeModel *timeModel() const;
	void setTimeModel(TimeModel *value);

	TimeModel *originModel() const;
	void setOriginModel(TimeModel *value);

	Q_INVOKABLE void addCategory(int uid, QString text, int color);
	Q_INVOKABLE void clearCategories();

	Q_INVOKABLE void recount();

	Q_ENUMS(Rows)

signals:
	void timeModelChanged();
	void originModelChanged();

private:
	struct Category {
		Category(QString t, int c): text(t), color(c), number(0) {}
		Category(): color(-1), number(0) {}
		QString text;
		int color;
		int number;
	};

	TimeModel* mTimeModel;
	TimeModel* mOriginModel;

	double mPrecision;
	double mQuantity;

	QMap<int, Category> mCats;
	QList<int> mCatUids;
};

#endif // TIMESTATMODEL_H
