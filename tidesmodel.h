#ifndef TIDESMODEL_H
#define TIDESMODEL_H

#include <QAbstractListModel>

struct ModelData {
    QString date;
    QString time;
    QString tide;
};

class TidesModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit TidesModel(QObject* parent = 0);

    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QStringList locations() const;

    Q_PROPERTY(QString currentLocation
               READ getCurrentLocation
               WRITE setCurrentLocation
               NOTIFY currentLocationChanged)
    QString getCurrentLocation() const { return m_currentLocation; }
    void setCurrentLocation(const QString& location);

    Q_PROPERTY(QString currentLevel
               READ getCurrentLevel
               NOTIFY currentLevelChanged)
    QString getCurrentLevel() const { return m_currentLevel; }
signals:
    void currentLocationChanged();
    void currentLevelChanged();
private slots:
    void findCurrentLevel();
private:
    QString m_currentLocation;
    int m_currentLocationId;
    QString m_currentLevel;
    QList<ModelData> m_data;
};

#endif // TIDESMODEL_H
