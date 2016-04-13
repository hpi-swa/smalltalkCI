"""
This script sends coverage information from smalltalkCI to coveralls.io.

It is based on: https://github.com/coagulant/coveralls-python.
"""

import json
import os
import subprocess
import sys

API_ENDPOINT = 'https://coveralls.io/api/v1/jobs'


def git_info():
        """ A hash of Git data that can be used to display more information to users.
            Example:
            "git": {
                "head": {
                    "id": "5e837ce92220be64821128a70f6093f836dd2c05",
                    "author_name": "Wil Gieseler",
                    "author_email": "wil@example.com",
                    "committer_name": "Wil Gieseler",
                    "committer_email": "wil@example.com",
                    "message": "depend on simplecov >= 0.7"
                },
                "branch": "master",
                "remotes": [{
                    "name": "origin",
                    "url": "https://github.com/lemurheavy/coveralls-ruby.git"
                }]
            }
        """

        rev = run_command('git', 'rev-parse', '--abbrev-ref', 'HEAD').strip()
        remotes = run_command('git', 'remote', '-v').splitlines()
        git_info = {'git': {
            'head': {
                'id': gitlog('%H'),
                'author_name': gitlog('%aN'),
                'author_email': gitlog('%ae'),
                'committer_name': gitlog('%cN'),
                'committer_email': gitlog('%ce'),
                'message': gitlog('%s'),
            },
            'branch': os.environ.get('TRAVIS_BRANCH', rev),
            'remotes': [{'name': line.split()[0], 'url': line.split()[1]}
                        for line in remotes if '(fetch)' in line]
        }}
        return git_info


def run_command(*args):
    cmd = subprocess.Popen(
            list(args), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = cmd.communicate()
    assert cmd.returncode == 0, ('command return code %d, STDOUT: "%s"\n'
                                 'STDERR: "%s"' % (cmd.returncode, stdout,
                                                   stderr))
    try:
        output = stdout.decode()
    except UnicodeDecodeError:
        output = stdout.decode('utf-8')
    return output


def gitlog(format):
    try:
        log = str(run_command('git', '--no-pager', 'log', '-1',
                              '--pretty=format:%s' % format))
    except UnicodeEncodeError:
        log = unicode(run_command('git', '--no-pager', 'log', '-1',
                                  '--pretty=format:%s' % format))
    return log


def main(directory):
    filename = '%s/coverage.json' % directory
    coveralls_json = '%s/coveralls.json' % directory

    if not os.path.isfile(filename):
        print 'No coverage.json file found in "%s"' % directory
        sys.exit(0)

    with open(filename, 'r') as f:
        try:
            source_files = json.load(f)
        except ValueError as e:
            print 'Invalid coverage.json file: %s' & str(e)
            sys.exit(1)

        if not source_files:
            print 'coverage.json file is empty' & str(e)
            sys.exit(0)

        data = {
            'service_job_id': os.environ.get('TRAVIS_JOB_ID'),
            'service_name': 'travis-ci',
            'source_files': source_files,
        }

        data.update(git_info())

    with open(coveralls_json, 'w') as f:
        f.write(json.dumps(data))

    post_request = run_command('curl', '-F',
                               'json_file=@%s' % coveralls_json,
                               API_ENDPOINT)
    print 'Coveralls: ' + json.loads(post_request)['message']


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'This program expects one parameter.'
        sys.exit(1)

    main(sys.argv[1])
