#include "plaunchercontroller.h"
#include "plauncher.h"
#include <QDebug>

PlauncherController::PlauncherController(QObject *parent) : QObject(parent) {

}

void PlauncherController::OnStdoutHasData(QString output) {
    emit sig_stdHasData(output);
}

void PlauncherController::launchProcessWithArg(const QString &file,const QStringList &args) {
  qDebug() << "###going launch Process:[" << file << "] with arguments [" << args << "]###";

  QThread *thread = new QThread( );
  Plauncher* execlauncher   = new Plauncher();
  execlauncher->moveToThread(thread);

  //start the launch work when thread start run
  connect(thread, &QThread::started, execlauncher, &Plauncher::OnPrelaunchProcess);
  connect(this, &PlauncherController::launchWithArg, execlauncher, &Plauncher::OnlaunchApp);

  connect(execlauncher, &Plauncher::stdoutHasData, this, &PlauncherController::OnStdoutHasData);

  //connect(execlauncher, &Plauncher::processExit, thread, SLOT(quit()) );
  //automatically delete thread and task object when work is done:
  connect( thread, SIGNAL(finished()), execlauncher, SLOT(deleteLater()) );
  connect( thread, SIGNAL(finished()), thread, SLOT(deleteLater()) );

  thread->start(); //call Plauncher::PrelaunchProcess()
  emit launchWithArg(file, args);
}

