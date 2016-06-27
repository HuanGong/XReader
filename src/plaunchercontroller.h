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


signals:
    void launchWithArg(QString file, QStringList args);

public slots:
    /* connect to signal recieve stdout output*/
    void OnStdoutHasData(QString &output);

private:
    QThread m_wthread;
};


#endif // PLAUNCHERCONTROLLER_H
