#!/usr/bin/python

env_vars = {}


def read_file(path):
    try:
        with open(path, 'r') as f:
            return f.read().strip()
    except IOError:
        return None


def get_memory_limit():
    limit = read_file('/sys/fs/cgroup/memory/memory.limit_in_bytes')
    if limit:
        env_vars['MEMORY_LIMIT_IN_BYTES'] = limit


def get_number_of_cores():
    core_count = 0

    line = read_file('/sys/fs/cgroup/cpuset/cpuset.cpus')
    if line is None:
        return

    for group in line.split(','):
        core_ids = list(map(int, group.split('-')))
        if len(core_ids) == 2:
            core_count += core_ids[1] - core_ids[0] + 1
        else:
            core_count += 1

    env_vars['NUMBER_OF_CORES'] = str(core_count)

get_memory_limit()
get_number_of_cores()

for item in env_vars.items():
    print("=".join(item))
