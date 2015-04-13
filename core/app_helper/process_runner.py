import os
import subprocess
import queue
from threading import Thread

from PyQt5.QtCore import pyqtSlot


class ProcessRunner:
    """
    Mixin for BasicApp that handles running external processes.
    Works only with BasicApp, as it expects the log method to be available.
    """

    def read_process_line(self, line):
        self.log(str(line).replace("\n", "<br />"))

    def read_process_error_line(self, line):
        self.log("<p style='color: red;'>"+str(line)+"</p>")

    def __process_stdout_stderr(self, stdout, stderr):
        while True:
            line = stderr.readline()
            if line != b'':
                self.read_process_error_line(line.rstrip().decode("utf-8"))
                continue
            line = stdout.readline()
            if line != b'':
                self.read_process_line(line.rstrip().decode("utf-8"))
            else:
                break
        stdout.close()
        stderr.close()

    @staticmethod
    def __process_output_stdout(pipe, q):
        for line in iter(pipe.readline, b''):
            q.put((0, line.decode("utf-8")))
        pipe.close()

    @staticmethod
    def __process_output_stderr(pipe, q):
        for line in iter(pipe.readline, b''):
            q.put((1, line.decode("utf-8")))
        pipe.close()

    @staticmethod
    def __write_output(q, stdout, stderr):
        for typ, line in iter(q.get, None):
            if typ == 0:
                stdout(line)
            else:
                stderr(line)

    @staticmethod
    def check_pid_exists(pid):
        """ Check for the existence of a unix pid.
            (http://stackoverflow.com/questions/568271/how-to-check-if-there-exists-a-process-with-a-given-pid)
        """
        try:
            os.kill(pid, 0)
        except OSError:
            return False
        else:
            return True

    @pyqtSlot(name="killProc")
    def kill_proc(self):
        for proc in list(self.running_procs):
            import signal
            if self.check_pid_exists(proc.pid):
                os.kill(proc.pid, signal.SIGTERM)
                self.running_procs.remove(proc)
            else:
                self.running_procs.remove(proc)

    def run_process(self, args, env={}, stdout=None, stderr=None, **kwargs):
        proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, close_fds=True, bufsize=1,
                                preexec_fn=os.setsid, **kwargs)
        self.running_procs.append(proc)
        q = queue.Queue()
        t_out = Thread(target=self.__process_output_stdout, args=(proc.stdout, q))
        t_err = Thread(target=self.__process_output_stderr, args=(proc.stderr, q))

        if stdout is None:
            stdout = self.read_process_line
        if stderr is None:
            stderr = self.read_process_error_line
        t_write = Thread(target=self.__write_output, args=(q, stdout, stderr))

        for t in (t_out, t_err, t_write):
            t.daemon = True
            t.start()

        result = proc.wait()
        for t in (t_out, t_err):
            t.join()
        q.put(None)
        return result

