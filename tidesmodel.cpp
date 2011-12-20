#include "tidesmodel.h"
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QStringList>
#include <QStringListModel>
#include <QSettings>
#include <QDebug>

enum {
    ROLE_DATE = 0,
    ROLE_TIME,
    ROLE_TIDE,
    ROLE_COUNT
};

TidesModel::TidesModel(QObject* parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roleNames;
    roleNames.insert(ROLE_DATE, "date");
    roleNames.insert(ROLE_TIME, "time");
    roleNames.insert(ROLE_TIDE, "tide");
    setRoleNames(roleNames);

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("tides.sqlite3");
    if (!db.open())
        qFatal("Failed to open database!");

    QSettings cfg;
    QString loc = cfg.value("location").toString();
    if (!loc.isEmpty())
        setCurrentLocation(loc);
}

int TidesModel::rowCount(const QModelIndex&) const
{
    return m_data.size();
}

QVariant TidesModel::data(const QModelIndex& index, int role) const
{
    if (role >= ROLE_COUNT || index.row() >= m_data.size())
        return QVariant();

    const ModelData& item = m_data[index.row()];
    switch(role) {
    case ROLE_DATE:
        return item.date;
    case ROLE_TIME:
        return item.time;
    case ROLE_TIDE:
        return item.tide;
    default:
        return QVariant();
    }
}

QStringList TidesModel::locations() const
{
    QStringList result;
    QSqlQuery q("SELECT name FROM locations ORDER BY name");
    while (q.next())
        result.append(q.value(0).toString());
    return result;
}

void TidesModel::setCurrentLocation(const QString& location)
{
    if (location == m_currentLocation)
        return;

    m_currentLocation = location;
    emit currentLocationChanged();

    // Get shipyard code
    QSqlQuery query;
    query.prepare("SELECT id FROM locations WHERE name=?");
    query.addBindValue(location);
    query.exec();

    query.next();
    int id = query.value(0).toInt();

    query.prepare("SELECT date, time, tide FROM tides WHERE locationId=? AND date BETWEEN ? AND ?");
    QString startDate = QDate::currentDate().toString("yyMMdd");
    QString endDate = QDate::currentDate().addDays(5).toString("yyMMdd");
    query.addBindValue(id);
    query.addBindValue(startDate);
    query.addBindValue(endDate);
    query.exec();

    m_data.clear();
    ModelData item;
    while (query.next()) {
        int n = query.value(0).toInt();
        item.date.sprintf("%02d/%02d/%02d", n % 100, (n / 100) % 100, n / 10000);
        n = query.value(1).toInt();
        item.time.sprintf("%02d:%02d", int(n / 100), int(n % 100));
        item.tide.setNum(query.value(2).toFloat(), 'f', 1);
        m_data.append(item);
    }
    reset();
    QSettings cfg;
    cfg.setValue("location", m_currentLocation);
}
