for p in reversed([
    r'C:\Program Files\7-Zip',
    r'C:\Program Files\Git\usr\bin'
]):
    if p not in $PATH:
        $PATH.insert(0, p)
$FZF_DEFAULT_OPTS = r'--height=40% --reverse'
$YAZI_FILE_ONE = r'C:\Program Files\Git\usr\bin\file.exe'

$XONSH_AUTOPAIR = True
$XONSH_STORE_STDOUT = True
$XONSH_SHOW_TRACEBACK = True
$XONSH_HISTORY_MATCH_ANYWHERE = True