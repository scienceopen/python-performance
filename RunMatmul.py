#!/usr/bin/env python
from pathlib import Path
import logging
import subprocess
from six import PY2

if PY2:
    FileNotFoundError=OSError


bdir='matmul'

def test_matmul(juliapath, N, Nrun):
    juliapath = Path(juliapath).expanduser() / 'julia'
    #%% Fortran
    try:
        print ('Fortran -->')
        subprocess.call(['./bin/matmul', str(N), str(Nrun)])
    except FileNotFoundError:
        logging.error('Fortran test skipped')

    #%% Julia
    try:
        print()
        subprocess.check_call([juliapath,'matmul.jl', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Julia executable not found')


    #%% GDL
    try:
        print('\n --> GDL')
        subprocess.check_call(['gdl','--version'])

        subprocess.check_call(['gdl','-q','-e','matmul','-args',str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('GDL executable not found')

    #%% IDL
    try:
        print('\n --> IDL')
        subprocess.check_call(['idl','--version'])

        subprocess.check_call(['idl','-q','-e','matmul','-args',str(N)],cwd=bdir)
    except FileNotFoundError:
        logging.warning('IDL executable not found')

    #%% Octave
    try:
        print()
        subprocess.check_call(['octave-cli','-q','--eval',f'matmul({N})'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Octave executable not found')

    #%% Matlab
    try:
        print()
        subprocess.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',f'matmul({N}); exit'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Matlab executable not found')


    #%% Python
    try:
        print()
        subprocess.check_call(['python','matmul.py', str(N), str(Nrun)], cwd=bdir)
    except FileNotFoundError:
        logging.error('Python test skipped')


# %%
from argparse import ArgumentParser
p = ArgumentParser()
p.add_argument('juliapath',help='path to julia executable',nargs='?',default='')
p.add_argument('-N',type=int,default=1000)
p.add_argument('-Nrun',type=int,default=10)
p = p.parse_args()

test_matmul(p.juliapath, p.N, p.Nrun)
