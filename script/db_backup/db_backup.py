import os
import sys
from ruamel.yaml import YAML
from datetime import datetime
from operator import itemgetter

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
BUFFER_INDEX_PATH = os.path.join(SCRIPT_PATH, 'db_backup_buffer_index.txt')


def main():
    # Load Config
    config_filepath = get_input_parameter('--config')
    config = get_config_from_file(config_filepath)

    # Get Info
    buffer_index = get_or_create_buffer_index(config['num_backup_stored'])
    backup_folder = config['local_folder']
    max_index = config['num_backup_stored']
    now = datetime.now()

    # Backup info
    backup_filename = 'DatabaseBackup_%02d_%04d-%02d-%02d_%02d-%02d-%02d.sql' % (buffer_index, now.year, now.month, now.day, now.hour, now.minute, now.second)
    backup_path = os.path.join(backup_folder, backup_filename)

    reorder_backup(backup_folder, max_index)
    backup(backup_path)
    delete_old_backup_local(backup_folder, buffer_index, max_index, [backup_filename, ])


def get_input_parameter(parameter):
    if parameter in sys.argv:
        index = sys.argv.index(parameter) + 1
        if len(sys.argv) > index:
            return sys.argv[index]
    raise ValueError('Parameter %s not present' % parameter)


def get_config_from_file(file):
    yaml = YAML(typ="safe")
    f = open(file, 'r+')
    config = yaml.load(f)
    f.close()
    return config


def get_or_create_buffer_index(max_index):
    if os.path.isfile(BUFFER_INDEX_PATH):
        with open(BUFFER_INDEX_PATH, "r") as f:
            index = int(f.read()) + 1
            if index >= max_index:
                index = 0
    else:
        index = 0
    with open(BUFFER_INDEX_PATH, "w+") as f:
        f.write(str(index))
    return index


def backup(file):
    with open(file, "w+") as f:
        f.write('test')


def get_backup_in_folder(backup_folder):
    all_file = os.listdir(backup_folder)
    backup_file = [f for f in all_file if f.startswith('DatabaseBackup_')]
    return backup_file


def delete_files(folder, files):
    for f in files:
        path = os.path.join(folder, f)
        os.remove(path)


def delete_old_backup_local(backup_folder, current_index, max_index, exclude):
    all_backup = get_backup_in_folder(backup_folder)
    backup_to_delete = []
    for f in all_backup:
        f_splits = f.split('_')
        f_index = int(f_splits[1])
        if f not in exclude:
            if f_index == current_index:
                backup_to_delete.append(f)
    delete_files(backup_folder, backup_to_delete)


# This function provide reorder in case of buffer size change
def reorder_backup(backup_folder, max_index):
    all_backup = get_backup_in_folder(backup_folder)
    backup_split = [b.split('_') for b in all_backup]
    if len(all_backup) > max_index:
        # Divide older backup from newer backup
        backup_sort_split = sorted(backup_split, key=itemgetter(2, 3))
        backup_to_rename_split = backup_sort_split[-max_index:]
        backup_to_delete_split = backup_sort_split[:-max_index]

        # Delete old backup
        backup_to_delete = ['_'.join(b) for b in backup_to_delete_split]
        delete_files(backup_folder, backup_to_delete)

        # Rename newer backup
        new_index = 0
        for b in backup_to_rename_split:
            old_path = os.path.join(backup_folder, '_'.join(b))
            b[1] = '%02d' % new_index
            new_path = os.path.join(backup_folder, '_'.join(b))
            os.rename(old_path, new_path)
            new_index += 1

        # Reset index
        with open(BUFFER_INDEX_PATH, "w+") as f:
            f.write(str(max_index-1))  # Next index is 0


if __name__ == "__main__":
    main()
