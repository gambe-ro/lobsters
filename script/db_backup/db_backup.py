import os
import sys
from datetime import datetime
from ruamel.yaml import YAML


BUFFER_INDEX_PATH = '.\\db_backup_buffer_index.txt'


def main():
    # Load Config
    config_filepath = get_input_parameter('--config')
    config = get_config_from_file(config_filepath)

    # Get Info
    buffer_index = get_or_create_buffer_index(config['num_backup_stored'])
    now = datetime.now()

    # Backup
    backup_filename = 'DatabaseBackup_%02d_%04d-%02d-%02d_%02d-%02d-%02d.sql' % (buffer_index, now.year, now.month, now.day, now.hour, now.minute, now.second)
    backup_path = os.path.join(config['local_folder'], backup_filename)
    backup(backup_path)
    delete_old_backup_local(config['local_folder'], buffer_index, config['num_backup_stored'], [backup_filename, ])


def get_input_parameter(parameter):
    if parameter in sys.argv:
        index = sys.argv.index(parameter) + 1
        if len(sys.argv) > index:
            return sys.argv[index]
    raise ValueError('Parametro %s non presente' % parameter)


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


def delete_old_backup_local(backup_folder, current_index, max_index, exclude):
    all_backup = os.listdir(backup_folder)
    backup_to_delete = []
    for f in all_backup:
        f_splits = f.split('_')
        f_app = f_splits[0]
        if f not in exclude:
            if f_app == 'DatabaseBackup':
                f_index = int(f_splits[1])
                if f_index == current_index or f_index >= max_index:
                    backup_to_delete.append(f)
    for f in backup_to_delete:
        path = os.path.join(backup_folder, f)
        os.remove(path)


if __name__ == "__main__":
    main()
