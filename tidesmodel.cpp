#include "tidesmodel.h"
#include <QDate>
#include <QDebug>

enum {
    ROLE_DATE = 0,
    ROLE_TIME,
    ROLE_TIDDE,
    ROLE_COUNT
};

TidesModel::TidesModel(QObject* parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roleNames;
    roleNames.insert(ROLE_DATE, "date");
    roleNames.insert(1, "time");
    roleNames.insert(1, "tide");
    setRoleNames(roleNames);

    qWarning() << QDate::currentDate();
}

int TidesModel::rowCount(const QModelIndex& parent) const
{
    return 0;
}

QVariant TidesModel::data(const QModelIndex& index, int role) const
{
    if (role >= ROLE_COUNT)
        return QVariant();
    return QVariant();
}
