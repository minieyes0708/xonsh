__functions = dict()

def __add_function(key):
    def inner(func):
        __functions[key] = func
    return inner

def __es_select(args):
    import subprocess
    es_proc = subprocess.Popen(['es'] + args, stdout=subprocess.PIPE)
    fzf_proc = subprocess.Popen(['fzf', '--height=40%', '--reverse'], stdin=es_proc.stdout, stdout=subprocess.PIPE)
    fzf_proc.wait()
    return fzf_proc.stdout.read().rstrip().decode('utf8')

def __fzf_select(values):
    import subprocess
    fzf_proc = subprocess.run(['fzf', '--height=40%', '--reverse'], input='\n'.join(values).encode('utf8'), stdout=subprocess.PIPE)
    return fzf_proc.stdout.rstrip().decode('utf8')

@__add_function('git log')
def __git_log(args):
    TortoiseGitProc.exe -path . -command log&

@__add_function('git diff')
def __git_diff(args):
    TortoiseGitProc.exe -path . -command diff&

@__add_function('git pull')
def __git_pull(args):
    TortoiseGitProc.exe -path . -command pull&

@__add_function('git push')
def __git_push(args):
    TortoiseGitProc.exe -path . -command push&

@__add_function('git blame')
def __git_blame(args):
    TortoiseGitProc.exe -path @(args[0]) -command blame&

@__add_function('git commit')
def __git_commit(args):
    TortoiseGitProc.exe -path . -command commit&

@__add_function('git revert')
def __git_revert(args):
    TortoiseGitProc.exe -path . -command revert&

@__add_function('git log on current file')
def __git_log_on_current_file(args):
    TortoiseGitProc.exe -path @(args[0]) -command log&

@__add_function('git diff with prev version')
def __git_diff_with_prev_version(args):
    TortoiseGitProc.exe -command showcompare -revision1 HEAD^ -revision2 HEAD&

@__add_function('svn log')
def __svn_log(args):
    TortoiseProc.exe -path . -command:log&

@__add_function('svn diff')
def __svn_diff(args):
    TortoiseProc.exe -path . -command:diff&

@__add_function('svn pull')
def __svn_pull(args):
    TortoiseProc.exe -path . -command:pull&

@__add_function('svn update')
def __svn_update(args):
    TortoiseProc.exe -path . -command:update&

@__add_function('svn commit')
def __svn_commit(args):
    TortoiseProc.exe -path . -command:commit&

@__add_function('goto subdirectory')
def __goto_subdirectory(args):
    cd $(fd --type d --max-depth 3 | fzf)

@__add_function('start file')
def __start_file(args):
    import os
    os.startfile(__es_select(args))

@__add_function('run program')
def __run_program(args):
    import subprocess
    subprocess.run(__fzf_select(line.strip() for line in open(p'$DotConfig/programs.txt').readlines()), shell=True)

@__add_function('edit program')
def __edit_program(args):
    code -r $DotConfig/programs.txt

@__add_function('add bin script')
def __add_bin_script(args):
    code -r D:\minieyes\software\bin\@(input('script name: '))

@__add_function('add bookmark')
def __add_bookmark(args):
    echo $(pwd) >> $DotConfig\bookmarks.txt

@__add_function('edit bookmark')
def __edit_bookmark(args):
    code -r $DotConfig/bookmarks.txt

@__add_function('goto bookmark')
def __goto_bookmark(args):
    cd @(__fzf_select(line.strip() for line in open(p'$DotConfig/bookmarks.txt', encoding='utf8').readlines()))

@__add_function('goto program folder')
def __goto_program_folder(args):
    import pathlib
    cd @(__fzf_select(str(v) for v in pathlib.Path('D:/minieyes_chen/program').iterdir() if v.is_dir()))

@__add_function('show stock')
def __show_stock(args):
    import os
    os.startfile('https://statementdog.com/analysis/{}/long-term-and-short-term-monthly-revenue-yoy'.format(input('Stock ID: ')))

@__add_function('search dictionary')
def __search_dictionary(args):
    import requests
    from bs4 import BeautifulSoup

    response = requests.get('https://tw.dictionary.search.yahoo.com/search?p={}'.format(input('Search Text: ')), proxies={'http': $HTTP_PROXY, 'https': $HTTPS_PROXY}, verify=False)
    print(BeautifulSoup(response.content, 'html.parser').find('div', {'class': 'grp-main'}).get_text())

@__add_function('set vifm location')
def __set_vifm_location(args):
    import os
    vifm --server-name vifm --remote +@('cd ' + os.getcwd().replace('\\','/'))

@__add_function('show cursor position')
def __show_cursor_position(args):
    import time, threading, pyautogui
    running = True
    def show_cursor_position():
        while running:
            time.sleep(1)
            current_mouse_x, current_mouse_y = pyautogui.position()
            print(f"\r當前滑鼠座標: X={current_mouse_x}, Y={current_mouse_y}")
    mythread = threading.Thread(target=show_cursor_position)
    mythread.daemon = True
    mythread.start()
    input('Press Enter To Stop')
    running = False
    mythread.join()

@__add_function('change folder permissions')
def __change_folder_permissions(args):
    cmd /c takeown /F %1 /R /D Y; cmd /c icacls %1 /grant:r @(input('User Acount: ')):F /T

def _x(args):
    if len(args):
        if   args[0] == 'p':        __functions['run program'](args)
        elif args[0] == 'sf':       __functions['start file'](args)
        elif args[0] == 'gb':       __functions['goto bookmark'](args)
        elif args[0] == 'cd':       __functions['goto subdirectory'](args)
        elif args[0] == 'gpr':      __functions['goto program folder'](args)
        elif args[0] == 'spr':      __functions['start file'](args[1:] + ['-path', 'D:/minieyes_chen/program'])
        elif args[0] == 'dict':     __functions['search dictionary'](args)
        else:
            selection = __fzf_select(__functions.keys())
            if selection: __functions[selection](args)
    else:
        selection = __fzf_select(__functions.keys())
        if selection: __functions[selection](args)
aliases['x'] = _x
aliases['p'] = __functions['run program']
aliases['sf'] = __functions['start file']
aliases['gb'] = __functions['goto bookmark']
aliases['xcd'] = __functions['goto subdirectory']
aliases['gpr'] = __functions['goto program folder']
aliases['spr'] = lambda args: __functions['start file'](args + ['-path', 'D:/minieyes/program'])
aliases['dict'] = __functions['search dictionary']