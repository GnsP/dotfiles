#!/usr/bin/env python
from __future__ import print_function
import os
import shutil
import sys

def get_file_list():
    output = []
    for dirpath, dirnames, filenames in os.walk('./home/'):
        for filename in filenames:
            output.append(filename)
    return output


def backup_file(filename):
    #TODO: Make backup directory if not exist
    #BACKUP_LOCATION = os.path.join(os.path.expanduser('~'), 'home_backup')
    BACKUP_LOCATION = filename + '.install.bak'
    shutil.copy2(filename, BACKUP_LOCATION)
    print(filename, '->', BACKUP_LOCATION)


def backup_dupes(filelist):
    print('Backup:')
    number_of_files_backed_up = 0
    for filename in filelist:
        filename_in_home = os.path.join(os.path.expanduser('~'), filename)
        if os.path.isfile(filename_in_home):
            backup_file(filename_in_home)
            number_of_files_backed_up += 1
    return number_of_files_backed_up

def copy_files(filelist):
    print('TODO: Copy Files')

def setup_vim():
    os.system('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
    os.system('vim +PluginInstall +qa')


def main():
    filelist = get_file_list()
    number_of_files_backed_up = backup_dupes(filelist)
    print(number_of_files_backed_up, 'files backed up')
    copy_files(filelist)
    setup_vim()
    return 0

if __name__ == '__main__':
    sys.exit(main())
