for __path in (
    r'C:\Program Files\7-Zip',
    r'C:\Program Files\Git\usr\bin'
):
    if __path not in $PATH:
        $PATH.append(__path)
$FZF_DEFAULT_OPTS = r'--height=40% --reverse'
$YAZI_FILE_ONE = r'C:\Program Files\Git\usr\bin\file.exe'

$XONSH_AUTOPAIR = True
$XONSH_STORE_STDOUT = True
$XONSH_SHOW_TRACEBACK = True
$XONSH_HISTORY_MATCH_ANYWHERE = True