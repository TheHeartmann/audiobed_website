"""
A simple script to initialise the local repo properly.
"""
import os


def init_gitconfig():
    'Add the custom .gitconfig to local config.'
    os.system('git config --local include.path ..{}.gitconfig'.format(os.path.sep))


def main():
    init_gitconfig()


if __name__ == '__main__':
    main()
