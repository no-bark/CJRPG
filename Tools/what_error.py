
import os
import os.path
import subprocess
import threading
import re

GODOT_VER = '4.5-stable_win64'

def script_paths(path):
    paths = []

    for root, dirs, files in os.walk(path):
        for filename in files:
            if os.path.splitext(filename)[1] == '.gd':
                paths.append(os.path.join(root, filename).replace('\\', '/'))

    return paths

class Command:
    cmd = None
    output = None
    error_output = None
    return_code = None

    def __init__(self, cmd):
        self.cmd = cmd

    def run(self):
        process = subprocess.Popen(self.cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, error_output = process.communicate()
        self.return_code = process.returncode

        self.output = output.decode('utf-8')
        self.error_output = error_output.decode('utf-8')

def check_errors_proc(cmds):
    for cmd in cmds:
        cmd.run()

def check_errors(path):
    path = path.replace('\\', '/')
    paths = script_paths(path)
    errors = []

    cmd_fmt = '{0} --check-only --headless --script {0} --quit'
    cmds = []

    for p in paths:
        cmd = cmd_fmt.format(GODOT_CONSOLE_EXE) + ' --script {0} --quit'.format(p)
        cmds.append(Command(cmd))

    thread_count = 12
    paths_per_thread = (len(cmds) + thread_count - 1) // thread_count
    threads = []
    for i in range(thread_count):
        start_index = i * paths_per_thread
        end_index = (i + 1) * paths_per_thread
        subcmds = cmds[start_index:end_index]
        t = threading.Thread(target=check_errors_proc, args=(subcmds,))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()

    script_error_tag = 'SCRIPT ERROR: '
    script_error_tag_len = len(script_error_tag)

    lineno_regex = re.compile('^.+\(res://(.+)\)$')

    for cmd in cmds:
        if len(cmd.error_output) == 0:
            continue

        lines = cmd.error_output.splitlines()
        errors = zip(lines[0::2], lines[1::2])
        for error in errors:
            if error[0].startswith(script_error_tag):
                m = lineno_regex.match(error[1])
                if m is not None:
                    info = error[0][script_error_tag_len:]
                    print('{0}: {1}'.format(os.path.join(path, m.group(1)).replace('\\', '/'),
                                           info))

if __name__ == '__main__':
    working_directory = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../'))
    prev_working_directory = os.getcwd()
    os.chdir(working_directory)

    GODOT_EXE_DIR = os.path.realpath('../../godot/')
    GODOT_EXE = os.path.join(GODOT_EXE_DIR, 'Godot_v{0}/Godot_v{0}.exe'.format(GODOT_VER))
    GODOT_CONSOLE_EXE = os.path.join(GODOT_EXE_DIR, 'Godot_v{0}/Godot_v{0}_console.exe'.format(GODOT_VER))

    check_errors(working_directory)

    os.chdir(prev_working_directory)

