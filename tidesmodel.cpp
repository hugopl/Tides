#include "tidesmodel.h"
#include <QDate>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QStringList>
#include <QStringListModel>
#include <QSettings>
#include <QTimer>
#include <QDebug>

#define DAYS_TO_SHOW 14
enum {
    ROLE_DATE = 0,
    ROLE_TIME,
    ROLE_TIDE,
    ROLE_COUNT
};

TidesModel::TidesModel(QObject* parent) : QAbstractListModel(parent), m_currentLocationId(-1)
{
    QHash<int, QByteArray> roleNames;
    roleNames.insert(ROLE_DATE, "date");
    roleNames.insert(ROLE_TIME, "time");
    roleNames.insert(ROLE_TIDE, "tide");
    setRoleNames(roleNames);

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    // hardcoded names ftw!
    db.setDatabaseName("/opt/Tides/tides.sqlite3");
    if (!db.open()) {
        // Try to open the local db as fallback
        db.setDatabaseName("tides.sqlite3");
        if (!db.open())
            qFatal("Failed to open database!");
    }

    QSettings cfg;
    QString loc = cfg.value("location").toString();
    if (!loc.isEmpty())
        setCurrentLocation(loc);

    QTimer* timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(findCurrentLevel()));
    // one call per 20mim
    timer->start(1000 * 60 * 20);
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

// Transform time number in format hhmm to number of minutes
inline int fixTime(int time)
{
    return int(time / 100) * 60 + (time % 100);
}

void TidesModel::findCurrentLevel()
{
    if (m_currentLocationId == -1)
        return;

    int today = QDate::currentDate().toString("yyMMdd").toInt();
    int now = QTime::currentTime().toString("hhmm").toInt();
    QSqlQuery query;

    query.prepare("SELECT date,time, tide FROM tides WHERE locationId = ? AND date <= ?  AND time <= ? ORDER BY date DESC,time DESC LIMIT 1");
    query.addBindValue(m_currentLocationId);
    query.addBindValue(today);
    query.addBindValue(now);
    query.exec();
    query.next();
    int startDate = query.value(0).toInt();
    int startTime = query.value(1).toInt();
    float startTide = query.value(2).toFloat();

    query.prepare("SELECT date,time,tide FROM tides WHERE locationId = ? AND date >= ?  AND time >= ? ORDER BY date,time DESC LIMIT 1");
    query.addBindValue(m_currentLocationId);
    query.addBindValue(today);
    query.addBindValue(now);
    query.exec();
    query.next();
    int endDate = query.value(0).toInt();
    int endTime = query.value(1).toInt();
    float endTide = query.value(2).toFloat();

    // Fix time if in diferrent dates
    if (startDate != today)
        endTime += 2400;
    if (endDate != today)
        endTime += 2400;

    // Fix time
    startTime = fixTime(startTime);
    endTime = fixTime(endTime);
    now = fixTime(now);
    // Do the interpolation stuff, fuck the precision!
    m_currentLevel = QString::number(startTide + (now - startTime) * ((endTide - startTide)/(endTime - startTime)), 'g', 3);
    emit currentLevelChanged();
}

void TidesModel::setCurrentLocation(const QString& location)
{
    if (location.isEmpty() || location == m_currentLocation)
        return;

    m_currentLocation = location;
    emit currentLocationChanged();

    // Get shipyard code
    QSqlQuery query;
    query.prepare("SELECT id FROM locations WHERE name=?");
    query.addBindValue(location);
    query.exec();

    query.next();
    m_currentLocationId = query.value(0).toInt();

    query.prepare("SELECT date, time, tide FROM tides WHERE locationId=? AND date BETWEEN ? AND ?");
    const QDate currentDate = QDate::currentDate();
    int startDate = currentDate.toString("yyMMdd").toInt();
    QString endDate = currentDate.addDays(DAYS_TO_SHOW).toString("yyMMdd");
    query.addBindValue(m_currentLocationId);
    query.addBindValue(startDate);
    query.addBindValue(endDate);
    query.exec();

    m_data.clear();
    ModelData item;


    while (query.next()) {
        int date = query.value(0).toInt();
        QDate d(2000 + date / 10000, (date / 100) % 100, date % 100);
        item.date = d.toString("ddd, d MMM");

        int time = query.value(1).toInt();
        item.time.sprintf("%02d:%02d", int(time / 100), int(time % 100));

        float tide = query.value(2).toFloat();
        item.tide.setNum(tide, 'f', 1);
        m_data.append(item);
    }

    findCurrentLevel();

    reset();
    QSettings cfg;
    cfg.setValue("location", m_currentLocation);
}
