#ifndef TIDESMODEL_H
#define TIDESMODEL_H

#include <QAbstractListModel>

class TidesModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit TidesModel(QObject* parent = 0);

    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QStringList locations() const;
signals:

public slots:

};

#endif // TIDESMODEL_H
