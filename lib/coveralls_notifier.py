import requests
import os
import json
import sys

from subprocess import Popen, PIPE

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
            # origin	git@github.com:coagulant/coveralls-python.git (fetch)
            'remotes': [{'name': line.split()[0], 'url': line.split()[1]}
                        for line in run_command('git', 'remote', '-v').splitlines() if '(fetch)' in line]
        }}
        return git_info


def run_command(*args):
    cmd = Popen(list(args), stdout=PIPE, stderr=PIPE)
    stdout, stderr = cmd.communicate()
    assert cmd.returncode == 0, ('command return code %d, STDOUT: "%s"\n'
                                 'STDERR: "%s"' % (cmd.returncode, stdout, stderr))
    try:
        output = stdout.decode()
    except UnicodeDecodeError:
        output = stdout.decode('utf-8')
    return output


def gitlog(format):
    try:
        log = str(run_command('git', '--no-pager', 'log', "-1", '--pretty=format:%s' % format))
    except UnicodeEncodeError:
        log = unicode(run_command('git', '--no-pager', 'log', "-1", '--pretty=format:%s' % format))
    return log


def main(directory):
    filename = '%s/.coverageReport' % directory

    if not os.path.isfile(filename):
        print 'coverageReport file not found in "%s"' % directory
        sys.exit(1)

    with open(filename, 'r') as f:
        try:
            source_files = json.load(f)
        except ValueError as e:
            print 'Invalid coverage JSON file: %s' & str(e)
            sys.exit(1)

        data = {
            'service_job_id': os.environ.get('TRAVIS_JOB_ID'),
            'service_name': 'travis-ci',
            'source_files': source_files,
        }

        data.update(git_info())
        print json.dumps(data)
        r = requests.post(API_ENDPOINT, files={'json_file': json.dumps(data)})
        print r.content


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'This program expects one parameter.'
        sys.exit(1)

    main(sys.argv[1])
