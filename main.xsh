import os, importlib

source $DotConfig/env.xsh
folder = os.path.dirname(__file__)

pushd @(folder)
for file in os.listdir(folder):
    if file in ['.git', 'main.xsh']: continue
    source @(file)
popd