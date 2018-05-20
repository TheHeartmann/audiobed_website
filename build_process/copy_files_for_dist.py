#!/usr/bin/env python3
'''
A script to move all contents of the frontend directory to a dist directory and
rename the files to '<file>@<commit>.<extension>', where commit is the short
hash of the last commit wherein the file was changed.
'''

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
        return '{}@{}'.format(self.name, self.revision)


def get_revision(x):
    return os.popen(
        'git log -n 1 --pretty=format:%h -- {}'.format(x)).read().strip()


def get_file_status(directory, extensions, ignore):
    file_status = []
    for dirpath, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if not re.match(ignore, d)]
        for f in [
                x for x in files if os.path.splitext(x)[1] in extensions
                and not re.match(ignore, x)
        ]:
            rev = get_revision(os.path.join(dirpath, f))
            relative_path = os.path.sep.join(
                os.path.join(dirpath, f).split(os.path.sep)[1:])
            file_status.append(FileStatus(relative_path, rev))
    return file_status


def elm_compile_to_file_status(output_dir, output_file, elm_dir, elm_file):
    output_file_relpath = os.path.join(output_dir, output_file)
    output_file_abspath = os.path.abspath(output_file_relpath)
    elm_file_abspath = os.path.abspath(os.path.join(elm_dir, 'src', elm_file))
    origin = os.getcwd()

    # create output dir
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    assert output_file not in os.listdir(
        output_dir), "The script will fail if {} is already present.".format(
            output_file_relpath)

    # elm-make
    os.chdir(os.path.abspath(elm_dir))
    return_code = os.system("elm-make {} --output={}".format(
        elm_file_abspath, output_file_abspath))
    os.chdir(origin)

    assert return_code == 0, "Could not compile elm file to {}".format(
        output_dir)

    rev = get_revision(elm_dir)
    relative_path = os.path.sep.join(
        output_file_relpath.split(os.path.sep)[1:])
    return FileStatus(relative_path, rev)


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


def ignore(pattern):
    def _ignore(_, content):
        return [x for x in content if re.match(pattern, x)]

    return _ignore


def main(root_dir, target_dir, extensions, ignore_pattern):
    origin = os.getcwd()
    try:
        os.chdir(root_dir)
        file_status_list = get_file_status(
            'frontend', ['.{}'.format(x) for x in extensions], ignore_pattern)

        # special cases
        # elm
        file_status_list.append(
            elm_compile_to_file_status(
                os.path.join('frontend', 'js'), 'elm.js',
                os.path.join('frontend', 'elm'), 'Main.elm'))

        if os.path.exists(target_dir):
            shutil.rmtree(target_dir)
        shutil.copytree('frontend', target_dir, ignore=ignore(ignore_pattern))
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
        help='The file types to change.',
        default='js css html')
    parser.add_argument(
        '-i', '--ignore', help='Patterns to ignore', default='^elm$')

    args = parser.parse_args()
    main(
        args.root,
        args.target,
        args.extensions.split(),
        ignore_pattern=args.ignore)
