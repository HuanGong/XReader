#include "plauncher.h"
#include "iostream"
#include <QStringList>
#include <QDebug>

Plauncher::Plauncher() :
    m_process(NULL) {
    m_process = new QProcess(this);

    connect(m_process, SIGNAL(finished(int , QProcess::ExitStatus )), this, SLOT(OnProcessExit(int , QProcess::ExitStatus )));
    connect(m_process, &QProcess::errorOccurred, this, &Plauncher::OnProcesserrorOccurred);
    printf("\nPlauncher::Plauncher\n");
}

Plauncher::~Plauncher() {
    printf("\nPlauncher::~Plauncher\n"); fflush(NULL);
    delete m_process;
}

void Plauncher::OnlaunchApp(const QString &program, const QStringList &argv) {
    std::cout << program.toStdString().c_str() << std::endl;


    //connect(m_process,SIGNAL(readyRead()),this, SLOT(OnReadyRead()));
    connect(m_process, &QProcess::readyRead, this, &Plauncher::OnReadyRead);

    m_process->start(program, argv);
    std::cout << m_process->processId() << std::endl;
    m_process->waitForFinished(-1);
}

void Plauncher::OnReadyRead() {
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    //std::cout << output.toStdString().c_str() << std::endl;

    stdoutHasData(output);
}

void Plauncher::OnPrelaunchProcess() {

}

//void Plauncher::OnProcessExit(int exitcode) {

void Plauncher::OnProcessExit(int exitcode, QProcess::ExitStatus exitStatus) {
    qDebug() << __FUNCTION__ << __LINE__;

    QThread::currentThread()->quit(); //emit quit to end this thread
}

void Plauncher::OnProcesserrorOccurred(QProcess::ProcessError error) {
    qDebug() << __FUNCTION__ << __LINE__;
    switch(error) {
    case QProcess::ProcessError::FailedToStart:

      //break;
    case QProcess::ProcessError::Crashed:

      //break;
    case QProcess::ProcessError::Timedout:

      //break;
    case QProcess::ProcessError::ReadError:

      //break;
    case QProcess::ProcessError::WriteError:

      //break;
    case QProcess::ProcessError::UnknownError:
      QThread::currentThread()->quit();
      break;
    default:
      break;
  }
}

