"""
A simple script to initialize the local repo properly.
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
    target_dir = os.path.join('.git', 'hooks')
    for base, _, files in os.walk(source_dir):
        for f in files:
            shutil.copy2(os.path.join(base, f), os.path.join(target_dir, f))
    print("Copied the following hooks to {}:\n\t{}".format(
        target_dir, '\n\t'.join(files)))


def main():
    print("Initializing repo.")
    init_gitconfig()
    copy_hooks()
    print("Initial repo configuration complete.")


if __name__ == '__main__':
    main()
