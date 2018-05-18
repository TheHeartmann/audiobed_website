#!/usr/bin/env python
"""
A script to move all contents of the frontend directory to a dist directory and
rename the files to '<file>@<commit>.<extension>', where commit is the short
hash of the last commit wherein the file was changed.
"""

import argparse
import os
import re
import shutil
import sys


class FileStatus():
    def __init__(self, file_name, revision):
        self.path, self.name = os.path.split(file_name)
        self.revision = revision

    def name_at_rev(self):
        return "{}@{}".format(self.name, self.revision)


def get_file_status(directory, extensions):
    file_status = []
    for dirpath, _, files in os.walk(directory):
        for f in [x for x in files if os.path.splitext(x)[1] in extensions]:
            rev = os.popen('git log -n 1 --pretty=format:%h -- {}'.format(
                os.path.join(dirpath, f))).read().strip()
            relative_path = os.path.sep.join(
                os.path.join(dirpath, f).split(os.path.sep)[1:])
            file_status.append(FileStatus(relative_path, rev))
    return file_status


def rename_files(dir, *file_statuses):
    try:
        for fs in file_statuses:

            def path(name):
                return os.path.join(dir, fs.path, name)

            os.rename(path(fs.name), path(fs.name_at_rev()))
    except Exception as e:
        print('Something went wrong while renaming files: {}'.format(e))
        return False
    return True


def rename_references(dir, *file_statuses):
    replacement_dict = {
        re.escape(x.name): x.name_at_rev()
        for x in file_statuses
    }

    def replace(text):
        return re.sub('|'.join(replacement_dict.keys()),
                      lambda x: replacement_dict[re.escape(x.group())], text)

    for dirpath, _, files in os.walk(dir):
        for f in files:
            path = os.path.join(dirpath, f)
            with open(path, 'r', encoding='utf8') as file:
                content = file.read()
            with open(path, 'w', encoding='utf8') as file:
                file.write(replace(content))


def main(root_dir, target_dir, *extensions):
    origin = os.getcwd()
    try:
        os.chdir(root_dir)
        file_status_list = get_file_status(
            'frontend', ['.{}'.format(x) for x in extensions])

        if os.path.exists(target_dir):
            shutil.rmtree(target_dir)
        shutil.copytree('frontend', target_dir)
        if rename_files(target_dir, *file_status_list):
            rename_references(target_dir, *file_status_list)
            rename_references(
                os.path.join('backend', 'src'), *file_status_list)
    except Exception as e:
        print('Something went terribly wrong: {}'.format(e))
        sys.exit(1)
    finally:
        os.chdir(origin)


if __name__ == '__main__':
    # set working dir
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-r', '--root', help='The directory to treat as root', default='.')
    parser.add_argument(
        '-t',
        '--target',
        help='The directory to copy files to.',
        default='dist')
    parser.add_argument(
        '-e',
        '--extensions',
        help='The file types to copy and treat.',
        default='js css html')
    args = parser.parse_args()
    main(args.root, args.target, *args.extensions.split())
