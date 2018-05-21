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

import subprocess
from subprocess import PIPE


class FileStatus():
    def __init__(self, file_name, revision):
        self.path, self.name = os.path.split(file_name)
        self.extension = os.path.splitext(self.name)[1]
        self.revision = revision

    def name_at_rev(self):
        return '{}@{}'.format(self.name, self.revision)


class CmdResult():
    def __init__(self, return_code, output):
        self.return_code = return_code
        self.output = output


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

            file_path = path(fs.name)
            minify(file_path)
            os.rename(file_path, path(fs.name_at_rev()))
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


def get_command(ext, source, target):
    commands = {
        '.js': {
            'cmd': 'uglifyjs {} -o {}',
            'options': ['-m']
        },
        '.css': {
            'cmd': 'postcss {} -o {}',
            'options': ['--no-map']
        },
        '.html': {
            'cmd':
            'html-minifier {} -o {}',
            'options': [
                '--collapse-boolean-attributes',
                '--collapse-inline-tag-whitespace', '--collapse-whitespace',
                '--minify-css true', '--minify-js true', '--remove-comments',
                '--remove-empty-attributes', '--remove-redundant-attributes',
                '--remove-script-type-attributes',
                '--remove-style-link-type-attributes'
            ]
        }
    }
    cmd_dict = commands.get(ext)
    if not cmd_dict:
        return None
    cmd = cmd_dict.get('cmd').format(source, target)
    return '{} {}'.format(cmd, ' '.join(cmd_dict.get('options', []))).strip()


def run_command(cmd):
    try:
        print('Running command {}'.format(cmd))
        return CmdResult(0, subprocess.check_output(cmd.split(), stderr=PIPE))
    except subprocess.CalledProcessError as e:
        return CmdResult(e.returncode, e.output)
    except Exception as e:
        raise Exception("Encountered an unexpected exception: {}".format(e))


def bundle(source_dir, target_dir, *file_statuses):
    '''Minify and copy files to dist folder'''
    results = []
    for f in file_statuses:
        target_path = os.path.join(target_dir, f.path)
        if not os.path.exists(target_path):
            os.makedirs(target_path)

        source = os.path.join(source_dir, f.path, f.name)
        target = os.path.join(target_dir, f.path, f.name_at_rev())
        results.append(run_command(get_command(f.extension, source, target)))

    return results


def main(root_dir, target_dir, extensions, ignore_pattern):
    origin = os.getcwd()
    try:
        os.chdir(root_dir)
        file_status_list = get_file_status(
            'frontend', ['.{}'.format(x) for x in extensions], ignore_pattern)

        special_cases = ['elm.js']
        # filter out special cases that may have been picked up
        file_status_list = [
            x for x in file_status_list if x.name not in special_cases
        ]

        # handle special cases
        # elm
        file_status_list.append(
            elm_compile_to_file_status(
                os.path.join('frontend', 'js'), 'elm.js',
                os.path.join('frontend', 'elm'), 'Main.elm'))

        if os.path.exists(target_dir):
            shutil.rmtree(target_dir)

        bundle_results = bundle('frontend', target_dir, *file_status_list)
        errors = [x for x in bundle_results if x.return_code != 0]
        if errors:
            error_messages = '\n\t'.join([x.output for x in errors])
            raise Exception(
                'There were errors while bundling source files to {}:\n\t{}'.
                format(target_dir, error_messages))
        # shutil.copytree('frontend', target_dir, ignore=ignore(ignore_pattern))
        # if rename_files(target_dir, *file_status_list):
        rename_references(target_dir, *file_status_list)
        rename_references(os.path.join('backend', 'src'), *file_status_list)

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
