#include "tidesmodel.h"
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QStringList>
#include <QStringListModel>
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

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("tides.sqlite3");
    if (!db.open())
        qCritical() << "Failed to open database! " << db.lastError().text();
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

QStringList TidesModel::locations() const
{
    QStringList result;
    QSqlQuery q("SELECT name FROM locations ORDER BY name");
    while (q.next())
        result.append(q.value(0).toString());
    return result;
}
