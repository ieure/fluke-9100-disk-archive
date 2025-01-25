#! /usr/bin/env python3

import sys
from functools import reduce
from itertools import chain
from os.path import basename


# Status must be defined in worst-to-best order, or combine_statuses()
# will break.
_MEDIA_STATUSES = [
    'X', # Unknown
    'M', # Modified media, sectors have been rewritten.
    'O', # Original media, no modified sectors.
]


_DUMP_STATUSES = [
    'B', # Bad dump, contains bad sectors.
    'G', # Good dump, no bad sectors.
]


def dumplog_statuses(f):
    """Yield lists of [MEDIA-STATUS, DISK-STATUS] for a DTC log.

    Yields one status per sector dumped.
    """
    with open(f, 'r') as fd:
        for line in fd.readlines():
            if 'MFM:' not in line:
                continue
            elif 'MFM: OK,' in line:
                yield ['O', 'G']
            elif 'MFM: OK*,' in line:
                yield ['M', 'G']
            elif '<error>' in line:
                yield ['M', 'B']


def fold_status(defs, a, b):
    """Fold one sector status, returning the worse of the two."""
    return defs[sorted(defs.index(x) for x in (a, b))[0]]


def fold_status_pair(sa, sb):
    """Fold a list of [MEDIA-STATUS, DISK-STATUS] pairs, returning the worst."""
    return [
        fold_status(_MEDIA_STATUSES, sa[0], sb[0]),
        fold_status(_DUMP_STATUSES, sa[1], sb[1]),
    ]


def usage(myname):
    return f"""{basename(myname)}: DTC-LOG-FILE [...]"""


def main(myname, files):
    if not files:
        print(usage(myname))
        return 1

    print(''.join(
        reduce(fold_status_pair,
               chain.from_iterable(dumplog_statuses(f) for f in files))))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[0], sys.argv[1:]))
