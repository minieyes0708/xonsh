import os, pathlib

source $DotConfig/env.xsh
folder = os.path.dirname(__file__)

for file in os.listdir(folder):
    if file in ['.git', 'main.xsh']: continue
    source @(pathlib.Path(folder) / file)