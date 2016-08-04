#ifndef PLAUNCHERCONTROLLER_H
#define PLAUNCHERCONTROLLER_H

#include <QObject>
#include <QString>
#include <QThread>
#include <QStringList>

class PlauncherController : public QObject
{
    Q_OBJECT
public:
    explicit PlauncherController(QObject *parent = 0);

    void launchProcessWithArg(const QString &file,const QStringList &args);

signals:
    void launchWithArg(const QString &file,const QStringList &args);
    void sig_stdHasData(QString data);

public slots:
    /* connect to signal recieve stdout output*/
    void OnStdoutHasData(QString output);

private:
};


#endif // PLAUNCHERCONTROLLER_H
