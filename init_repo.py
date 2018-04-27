#!usr/bin/env python
"""
A simple script to initialize the local repo properly.
"""
import os
import re
import shutil


def log(message):
    print('{}\n'.format(message))


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
    for base, _, files in os.walk(source_dir):
        for f in files:
            shutil.copy2(os.path.join(base, f), os.path.join(target_dir, f))
    log("Copied the following hooks to {}:\n\t{}".format(
        target_dir, '\n\t'.join(files)))


def check_pandoc():
    '''
    Check if the user has pandoc installed, and if so, what version.
    If pandoc is not found, log a message suggesting installing it.
    '''
    print('Pandoc:')
    pandoc_version_string = os.popen('pandoc -v').readline()
    if not pandoc_version_string:
        log('''\tYou do not appear to have pandoc installed.
        Please install it before starting development.
        Note that the version in your package manager
        might be rather outdated (apt-get, for instance),
        so it might be preferable downloading it from
        the official releases page:
        https://github.com/jgm/pandoc/releases''')
        return False

    if int(re.search(r'^pandoc[\w \.]+?(\d)+\.', pandoc_version_string).group(1)) >= 2:
        log('''\tPandoc installation approved.''')
    else:
        log('''\tYour Pandoc installation is outdated.
        It should not be an immediate issue for this project,
        but please consider updating.''')
        return True


def main():
    log("Initializing repo.")
    init_gitconfig()
    copy_hooks()
    check_pandoc()
    log("Initial repo configuration complete.")


if __name__ == '__main__':
    main()
