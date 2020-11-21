import csv
import datetime
import os
import robot.output.output


def __init__():
    print 'hi'


def get_csv_length(filename):
    length = 0
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile)
        for _ in reader:
            length += 1
        return length


def read_from_csv(filename):
    data = []
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            data.append(row)
    return data


def read_from_csv_as_dict(filename):
    data = []
    with open(filename, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data.append(row)
    return data


def write_in_csv(filename, data, source='dict', write_mode='a'):
    if data is None:
        return
    csv_len = get_csv_length(filename)
    with open(filename, write_mode) as csvfile:
        if source == 'list':
            writer = csv.writer(csvfile)
        else:
            writer = csv.DictWriter(csvfile, fieldnames=data.keys())
        if csv_len == 0 and source == 'dict':
            writer.writeheader()
        writer.writerow(data)


def is_present_in_dictionary(current_dict, key):
    if key in current_dict:
        return True
    return False


def string_contains(parent_string, search_string):
    return search_string in parent_string


def find_in_string(parent_string, search_string):
    return parent_string.find(search_string)


def get_absolute_path(relative_path):
    return os.path.abspath(relative_path)


def format_date_time(in_date, current_format='%d/%m/%Y', new_format='%m/%d/%y'):
    return datetime.datetime.strptime(in_date, current_format).strftime(new_format)
