#include "plauncher.h"
#include "iostream"
#include <QStringList>

Plauncher::Plauncher() :
    m_process(NULL) {
    m_process = new QProcess(this);
    printf("\nPlauncher::Plauncher\n");
}

Plauncher::~Plauncher() {
    printf("\nPlauncher::~Plauncher\n");
}

void Plauncher::OnlaunchApp(const QString &program, const QStringList &argv) {
    std::cout << program.toStdString().c_str() << std::endl;
    QStringList arg;

    connect(m_process,SIGNAL(readyRead()),this, SLOT(OnReadyRead()));

    m_process->start(program, argv);
    m_process->waitForFinished(-1);
}

void Plauncher::OnReadyRead() {
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    std::cout << output.toStdString().c_str() << std::endl;

    emit stdoutHasData(output);
}


