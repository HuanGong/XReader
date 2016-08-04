#ifndef PLAUNCHER_H
#define PLAUNCHER_H

#include <QObject>
#include <QProcess>
#include <QString>
#include <QThread>

class Plauncher: public QObject
{
    Q_OBJECT
public:
    Plauncher();
    virtual ~Plauncher();


public slots:
    /* connect to sig readready;
     * read the stdout and emit signal "stdoutDataChanged()"*/
    void OnReadyRead();
    void OnReadyReadStdOut();
    void OnReadyReadStdErr();



    /* triggled by controller, run a program with argv list */
    void OnlaunchApp(const QString &program, const QStringList &argv);

    void OnPrelaunchProcess();

    void OnProcessExit(int exitcode, QProcess::ExitStatus exitStatus);
    void OnProcesserrorOccurred(QProcess::ProcessError error);

signals:
    void stdoutHasData(QString bytes);

private:
    QProcess* m_process;
};

#endif // PLAUNCHER_H
