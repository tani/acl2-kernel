from ipykernel.kernelbase import Kernel
from pexpect import replwrap, EOF, TIMEOUT
import pexpect
import regex

from subprocess import PIPE, Popen
import signal
import re
import os

__version__ = '0.2.8'

class ACL2Kernel(Kernel):
    implementation = 'acl2_kernel'
    implementation_version = __version__

    @property
    def language_version(self):
        with Popen(os.environ['ACL2'], stdout=PIPE, stdin=PIPE) as p:
            p.stdin.close()
            return re.findall(r'ACL2 Version.*$', p.stdout.read().decode('utf-8'), re.MULTILINE)[0]
    
    @property
    def banner(self):
        return u'ACL2 Kernel (%s)' % self.language_version
    
    language_info = {
        'name': 'acl2',
        'codemirror_mode': 'commonlisp',
        'mimetype': 'text/x-common-lisp',
        'file_extension': '.lisp'
    }

    def __init__(self, **kwargs):
        Kernel.__init__(self, **kwargs)
        self._start_acl2()

    def _start_acl2(self):
        sig = signal.signal(signal.SIGINT, signal.SIG_DFL)
        try:
            prompt_change_cmd = '''
                    (encapsulate ()
                      (set-state-ok t)
                      (defun jupyter-prompt (channel state)
                        (declare (xargs :mode :program))
                        (fmt1 "JPY-ACL2>" '() 0 channel state nil)))
                    (defttag t)
                    (set-ld-prompt 'jupyter-prompt state)
                    (defttag nil)
                    (reset-prehistory)'''
            self.acl2wrapper = replwrap.REPLWrapper(os.environ['ACL2'], 'ACL2 !>', prompt_change_cmd, 'JPY-ACL2>')
            # Discard the output of prompt_change_cmd.
            for i in range(3):
                self.acl2wrapper.run_command(';', timeout=None)
        finally:
            signal.signal(signal.SIGINT, sig)
        
    def do_execute(self, code, silent, store_history=True, user_expressions=None, allow_stdin=False):
        if not code.strip():
            return {
                'status': 'ok',
                'execution_count': self.execution_count,
                'payload': [],
                'user_expressions': []
            }
        interrupted = False
        try:
            # Remove all comments from the code block.
            cmd = re.sub(r';.*$', '', code, flags=re.MULTILINE)

            # Count all commands in the code block. There are 2 types of
            # commands recognized:
            #
            # 1. Keyword commands, such as:
            #      :pl subsetp
            #    using the ^[ \t]*:.*$ regex. This is a simple recognizer that
            #    treats the whole line as the keyword command.
            # 2. Top-level LISP forms, such as:
            #      (defun app (x y)
            #        (cond ((endp x) y)
            #              (t (cons (car x)
            #                       (app (cdr x) y)))))
            #    using the \((?>[^()]|(?R))*\) regex.
            num_cmds = len(regex.findall(r'^[ \t]*:.*$|\((?>[^()]|(?R))*\)', cmd, regex.MULTILINE))

            # Convert all \r and \n into spaces.
            cmd = re.sub(r'[\r\n]', ' ', cmd.strip())

            output = self.acl2wrapper.run_command(cmd, timeout=None)
            for i in range(num_cmds - 1):
                output += self.acl2wrapper.run_command(';', timeout=None)
            while True:
                try:
                    more_output = self.acl2wrapper.run_command(';', timeout=0)
                except TIMEOUT:
                    break
                output += more_output
        except KeyboardInterrupt:
            self.acl2wrapper.child.sendintr()
            interrupted = True
            self.acl2wrapper._expect_prompt()
            output =  self.acl2wrapper.child.before
            self.process_output(output)
        except EOF:
            output = self.acl2wrapper.child.before + 'Restarting ACL2'
            self._start_acl2()
            self.process_output(output)
        if interrupted:
            return {
                'status': 'abort',
                'execution_count': self.execution_count
            }
        if not silent:
            stream_content = {
                'execution_count': self.execution_count,
                'name': 'stdout',
                'text': output
            }
            self.send_response(self.iopub_socket, 'stream', stream_content)
        return {
            'status': 'ok',
            'execution_count': self.execution_count,
            'payload': [],
            'user_expressions': {}
        }
