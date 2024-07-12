def __posh_get_command_context():
    last_cmd = __xonsh__.history[-1] if __xonsh__.history else None
    status = last_cmd.rtn if last_cmd else 0
    duration = round((last_cmd.ts[1] - last_cmd.ts[0]) * 1000) if last_cmd else 0
    return status, duration

def __posh_primary():
    status, duration = __posh_get_command_context()
    return $(oh-my-posh.exe print primary --config=@($POSH_THEME) --shell=xonsh --status=@(status) --execution-time=@(duration) --shell-version=@($XONSH_VERSION))

def __posh_right():
    status, duration = __posh_get_command_context()
    return $(oh-my-posh.exe print right --config=@($POSH_THEME) --shell=xonsh --status=@(status) --execution-time=@(duration) --shell-version=@($XONSH_VERSION))

def __random_prompt():
    import os, random
    THEME_FOLDER = 'C:/Users/nvt02863/.config/oh-my-posh/themes'
    THEME_FILE = random.choice($(ls THEME_FOLDER).splitlines())
    $POSH_THEME = os.path.join(THEME_FOLDER, THEME_FILE)

    $PROMPT = __posh_primary
    $RIGHT_PROMPT = __posh_right
aliases['random_prompt'] = __random_prompt

def __select_prompt_theme():
    import os
    THEME_FOLDER = 'C:/Users/nvt02863/.config/oh-my-posh/themes'
    THEME_FILE = $(ls THEME_FOLDER | fzf)
    if THEME_FILE:
        $POSH_THEME = os.path.join(THEME_FOLDER, THEME_FILE)

        $PROMPT = __posh_primary
        $RIGHT_PROMPT = __posh_right
aliases['select_prompt_theme'] = __select_prompt_theme

$PROMPT = __posh_primary
$RIGHT_PROMPT = __posh_right
$POSH_THEME = 'C:/Users/$USERNAME/.config/oh-my-posh/themes/catppuccin_frappe.omp.json'