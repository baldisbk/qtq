#include "timestatmodel.h"

#include "timemodel.h"

#include <QDebug>

TimeStatModel::TimeStatModel(QObject *parent): QAbstractItemModel(parent),
	mTimeModel(NULL), mOriginModel(NULL)
{
}

TimeStatModel::~TimeStatModel()
{
}

QModelIndex TimeStatModel::index(int row, int column, const QModelIndex &) const
{
	return createIndex(row, column);
}

QModelIndex TimeStatModel::parent(const QModelIndex &) const
{
	return QModelIndex();
}

int TimeStatModel::rowCount(const QModelIndex &) const
{
	return mCatUids.count() + numberOfBaseRows;
}

int TimeStatModel::columnCount(const QModelIndex &) const
{
	return 1;
}

QVariant TimeStatModel::data(const QModelIndex &index, int role) const
{
	switch(index.row()) {
	case Precision:
		switch (role) {
		case Qt::DisplayRole:
		case TextRole:
			return "Precision";
		case NumberRole:
			return QString("%1%").arg(int(mPrecision*100));
		case ColorRole:
			return -1;
		default:;
		}
		break;
	case Quantity:
		switch (role) {
		case Qt::DisplayRole:
		case TextRole:
			return "Quantity";
		case NumberRole:
			return QString("%1%").arg(int(mQuantity*100));
		case ColorRole:
			return -1;
		default:;
		}
		break;
	default:
		if (index.row() - numberOfBaseRows >= mCatUids.size())
			break;
		switch (role) {
		case Qt::DisplayRole:
		case TextRole:
			return mCats[mCatUids[index.row() - numberOfBaseRows]].text;
		case NumberRole:
			return QString::number(mCats[mCatUids[index.row() - numberOfBaseRows]].number);
		case ColorRole:
			return mCats[mCatUids[index.row() - numberOfBaseRows]].color;
		default:;
		}
	}
	return QVariant();
}

TimeModel *TimeStatModel::timeModel() const
{
	return mTimeModel;
}

void TimeStatModel::setTimeModel(TimeModel *value)
{
	mTimeModel = value;
	recount();
	emit timeModelChanged();
}

void TimeStatModel::recount()
{
	if (!mTimeModel || !mOriginModel)
		return;
	QMap<int, Category> cats;
	int noneOrigin = 0;
	int noneModel = 0;
	beginResetModel();

	mPrecision = 0;
	mQuantity = mTimeModel->rowCount();
	foreach(int uid, mCatUids)
		mCats[uid].number = 0;
	for(int i = 0; i < mTimeModel->rowCount(); ++i) {
		++(cats[mOriginModel->uid(i)].number);
		++(mCats[mTimeModel->uid(i)].number);
		if (mOriginModel->uid(i) == mTimeModel->uid(i))
			mPrecision += 1;
		if (mOriginModel->uid(i) == -1)
			++noneOrigin;
		if (mTimeModel->uid(i) == -1)
			++noneModel;
	}
	if (noneModel > noneOrigin)
		mQuantity -= noneModel - noneOrigin;
	foreach(int uid, mCatUids) {
		if (mCats[uid].number > cats[uid].number)
			mQuantity -= mCats[uid].number - cats[uid].number;
	}
	mPrecision /= mTimeModel->rowCount();
	mQuantity /= mTimeModel->rowCount();

	endResetModel();
}

TimeModel *TimeStatModel::originModel() const
{
	return mOriginModel;
}

void TimeStatModel::setOriginModel(TimeModel *value)
{
	mOriginModel = value;
	recount();
	emit originModelChanged();
}

void TimeStatModel::addCategory(int uid, QString text, int color)
{
	mCats[uid] = Category(text, color);
	mCatUids.append(uid);
}

void TimeStatModel::clearCategories()
{
	mCats.clear();
	mCatUids.clear();
	recount();
}

QHash<int, QByteArray> TimeStatModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles.insert(TextRole, "text");
	roles.insert(ColorRole, "colorId");
	roles.insert(NumberRole, "number");
	return roles;
}
