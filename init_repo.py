"""
A simple script to initialise the local repo properly.
"""
import os
import shutil


def init_gitconfig():
    'Add the custom .gitconfig to local config.'
    os.system('git config --local include.path ..{}.gitconfig'.format(os.path.sep))
    print("Added project .gitconfig to your local git config.")


def copy_hooks():
    '''
    Copy all hooks found in the .git_hooks dir to .git/hooks for systems with
    git versions < 2.9.0
    '''
    source_dir = '.git_hooks'
    target_dir = '.git/hooks'
    for base, _, files in os.walk(source_dir):
        for f in files:
            shutil.copy2(os.path.join(base, f), os.path.join(target_dir, f))
    print("Copied the following hooks to {}: {}".format(target_dir, ', '.join(files)))


def main():
    print("Initiating repo.")
    init_gitconfig()
    copy_hooks()


if __name__ == '__main__':
    main()
