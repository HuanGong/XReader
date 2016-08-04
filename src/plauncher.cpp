#include "plauncher.h"
#include "iostream"
#include <QStringList>
#include <QDebug>

Plauncher::Plauncher() :
    m_process(NULL) {
    m_process = new QProcess(this);

    connect(m_process, SIGNAL(finished(int , QProcess::ExitStatus )), this, SLOT(OnProcessExit(int , QProcess::ExitStatus )));
    connect(m_process, &QProcess::errorOccurred, this, &Plauncher::OnProcesserrorOccurred);
    printf("\n###Plauncher::Plauncher be created###\n");
}

Plauncher::~Plauncher() {
    printf("\n###Plauncher::~Plauncher be destroyed###\n");
    delete m_process;
}

void Plauncher::OnlaunchApp(const QString &program, const QStringList &argv) {
    std::cout << program.toStdString().c_str() << std::endl;

    connect(m_process, &QProcess::readyRead, this, &Plauncher::OnReadyRead);
    connect(m_process, &QProcess::readyReadStandardOutput, this, &Plauncher::OnReadyReadStdOut);
    connect(m_process, &QProcess::readyReadStandardError, this, &Plauncher::OnReadyReadStdErr);

    m_process->start(program, argv);
    m_process->waitForFinished(-1);
}

void Plauncher::OnReadyRead() {
    QByteArray bytes = m_process->readAll();
    QString output = QString::fromLocal8Bit(bytes);

    stdoutHasData(output);
}

void Plauncher::OnPrelaunchProcess() {
    qDebug() << __FUNCTION__ << __LINE__;
}


void Plauncher::OnReadyReadStdOut() {
    qDebug() << __FUNCTION__ << __LINE__;
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);

    stdoutHasData(output);
}

void Plauncher::OnReadyReadStdErr() {
    qDebug() << __FUNCTION__ << __LINE__;
    QByteArray bytes = m_process->readAllStandardError();
    QString output = QString::fromLocal8Bit(bytes);

    stdoutHasData(output);
}

void Plauncher::OnProcessExit(int exitcode, QProcess::ExitStatus exitStatus) {
    qDebug() << __FUNCTION__ << __LINE__ << "exitcode:" << exitcode << "exitstatus" << exitStatus;

    QThread::currentThread()->quit(); //emit quit to end this thread
}

void Plauncher::OnProcesserrorOccurred(QProcess::ProcessError error) {
    qDebug() << __FUNCTION__ << __LINE__ << "error:[" << error << "]";
    switch(error) {
    case QProcess::ProcessError::FailedToStart:
      break;
    case QProcess::ProcessError::Crashed:
      break;
    case QProcess::ProcessError::Timedout:
      break;
    case QProcess::ProcessError::ReadError:
      break;
    case QProcess::ProcessError::WriteError:
      break;
    case QProcess::ProcessError::UnknownError:
      break;
    default:
      break;
  }
  QThread::currentThread()->quit();
}

