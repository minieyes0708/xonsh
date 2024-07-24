from xonsh.tools import unthreadable

@unthreadable
@aliases.register
def _yy(args):
    import os
    filename = os.path.expanduser('~/yazi_cwd_file')
    yazi @(args) --cwd-file=@(filename)

    cwd = open(filename, encoding='utf8').read()
    if cwd and cwd != $(pwd):
        cd @(cwd)
    os.unlink(filename)