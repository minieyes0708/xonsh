import os, importlib

folder = os.path.dirname(__file__)
cd @(folder)
for file in os.listdir(folder):
    if file in ['.git', 'main.xsh']: continue
    source @(file)
cd -