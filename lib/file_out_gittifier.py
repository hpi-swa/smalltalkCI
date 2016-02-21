#!/usr/bin/python

import sys
import os


if __name__ == '__main__':
    testing = len(sys.argv) > 2 and sys.argv[1] == '--testing'
    offset = 2 if testing else 1

    stFilesOnly = all([f.endswith('.st') for f in sys.argv[offset:]])
    filesExist = all([os.path.isfile(f) for f in sys.argv[offset:]])
    if len(sys.argv) < 2 or not stFilesOnly or not filesExist:
        print 'This program requires existing .st files as input parameter.'
        sys.exit(1)

    filenames = sys.argv[offset:]
    for filename in filenames:
        content = ''
        with open(filename, 'rb') as f:
            content = f.read()

        if testing:
            for line in content.splitlines(True):
                if b'\r' in line or b'\f' in line:
                    print '%s does not seem to be gittified.' % filename
                    sys.exit(1)
        else:
            with open(filename, 'wb') as f:
                for line in content.splitlines():
                    f.write(line.rstrip(b'\f') + b'\n')

    if testing:
        print 'Tested %s file(s).' % len(filenames)
    else:
        print 'Converted %s file(s).' % len(filenames)
