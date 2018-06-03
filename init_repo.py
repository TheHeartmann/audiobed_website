#!usr/bin/env python
# -*- coding: utf-8 -*-
"""
A simple script to initialize the local repo properly.
"""
import os
import re
import shutil


def log(message, indent=''):
    print('{}{}\n'.format(indent, message))


def init_gitconfig():
    'Add the custom .gitconfig to local config.'
    os.system('git config --local include.path ..{}.gitconfig'.format(
        os.path.sep))
    log("Added project .gitconfig to your local git config.")


def copy_hooks():
    '''
    Copy all hooks found in the .git_hooks dir to .git/hooks for systems with
    git versions < 2.9.0
    '''
    source_dir = '.git_hooks'
    target_dir = os.path.join('.git', 'hooks')
    ignored_files = re.compile(r'^.+\.pyc$')
    files_to_copy = [
        x for x in os.listdir(source_dir)
        if (os.path.isfile(os.path.join(source_dir, x))
            and not ignored_files.match(x))
    ]

    if not files_to_copy:
        log('No hooks to copy.')
        return

    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        log('Created target directory {}'.format(target_dir))
    for f in files_to_copy:
        shutil.copy2(os.path.join(source_dir, f), os.path.join(target_dir, f))
    log('Copied the following files to {}:\n\t{}'.format(
        target_dir, '\n\t'.join(files_to_copy)))


def check_yapf():
    '''
    Check whether the user has YAPF installed or not.
    If not, try to install it.
    '''
    print('YAPF:')
    if os.popen('yapf -v').readline():
        log('Installed: ✓', '\t')
        return True

    log('YAPF formatter was not found. Installing.', '\t')
    if os.system('pip install yapf'):
        log('Successfully installed YAPF', '\t')
        return True
    log('The YAPF installation failed. Please install it manually.', '\t')
    return False


def check_standard():
    '''
    Check whether standard is installed or not.
    '''
    print('Standard:')
    if os.popen('standard --version').readline():
        log('Installed: ✓', '\t')
        return True
    log('Standard not found. Please install it using `npm i -g standard`')
    return False


def main():
    log("Initializing repo.")
    init_gitconfig()
    copy_hooks()
    check_yapf()
    check_standard()
    log("Initial repo configuration complete.")


if __name__ == '__main__':
    main()
