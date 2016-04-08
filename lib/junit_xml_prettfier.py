#!/usr/bin/python
# -*- coding: utf-8 -*-

import glob
import os
import sys
import xml.etree.ElementTree as et

ANSI_BOLD = '\033[1m'
ANSI_RED = '\033[31m'
ANSI_GREEN = '\033[32m'
ANSI_YELLOW = '\033[33m'
ANSI_BLUE_BOLD = '\033[34;1m'
ANSI_GRAY = '\033[37m'
ANSI_GRAY_BOLD = '\033[37;1m'
ANSI_RESET = '\033[0m'
ANSI_CLEAR = '\033[0K'
SUCCESS = '✓'
FAIL = '✗'
TESTS = 0
TIME = 0
ERRORS = 0
FAILURES = 0
EXCEPTIONS = {}
IS_TRAVIS_BUILD = os.environ.get('TRAVIS') == 'true'
TRAVIS_FOLD_PREFIX = os.environ.get('SMALLTALK_CI_TRAVIS_FOLD_PREFIX', '')


def get_title(suite, tests, failures, errors, time):
    return '%s# %s: %s Tests, %s Failures, %s Errors in %ss%s' % (
      ANSI_BLUE_BOLD, suite, tests, failures, errors, time, ANSI_RESET)


def get_error(title, time):
    return '  %s%s %s%s (%s)' % (
      ANSI_RED, FAIL, title, ANSI_RESET, get_time(time))


def get_fail(title, time):
    return '  %s%s %s%s (%s)' % (
      ANSI_YELLOW, FAIL, title, ANSI_RESET, get_time(time))


def get_exception_title(ex_type, ex_msg):
    return '%s%s: %s%s' % (ANSI_GRAY_BOLD, ex_type, ex_msg, ANSI_RESET)


def get_exception_body(body):
    return '%s%s%s' % (ANSI_GRAY, body, ANSI_RESET)


def get_time(time):
    try:
        time = float(time)
    except ValueError:
        print_error('%s is not a float.' % time)
        return time
    return '%.3f seconds' % time


def print_summary(index):
    if build_failed():
        color = ANSI_RED
    else:
        color = ANSI_GREEN

    if EXCEPTIONS:
        travis_fold('result_summary%s' % index, 'start')

    print '%s%s     Executed %s tests, with %s failures and %s errors in' \
          ' %s seconds.%s' % (
            ANSI_BOLD, color, TESTS, FAILURES, ERRORS, TIME,
            ANSI_RESET)

    if EXCEPTIONS:
        print ''
        for class_name, exceptions in EXCEPTIONS.iteritems():
            print_bold(class_name)
            [print_exception(*f) for f in exceptions]
        travis_fold('result_summary%s' % index, 'end')


def print_separator(color):
    print '%s%s%s' % (color, ''.join(['#']*80), ANSI_RESET)


def print_error(string):
    print '%s%s%s%s' % (ANSI_BOLD, ANSI_RED, string, ANSI_RESET)


def print_bold(string):
    print '%s%s%s' % (ANSI_BOLD, string, ANSI_RESET)


def print_success(title, time):
    print '  %s%s%s %s (%s)' % (
        ANSI_GREEN, SUCCESS, ANSI_RESET, title, get_time(time))


def build_failed():
    return ERRORS + FAILURES > 0


def travis_fold(name, start_or_end):
    if IS_TRAVIS_BUILD:
        print '%stravis_fold:%s:%s%s' % (
            ANSI_CLEAR, start_or_end, TRAVIS_FOLD_PREFIX, name)


def print_exception(name, title, body):
    travis_fold(name, 'start')
    print title
    if body and IS_TRAVIS_BUILD:
        print body
    travis_fold(name, 'end')


def prettify_class_name(suite, class_name, index):
    global TESTS, ERRORS, FAILURES

    for testcase in suite.findall('testcase[@classname="%s"]' % class_name):
        children = list(testcase)
        if len(children):
            body = []
            is_error = False
            for child in children:
                ex_type = child.attrib.get('type')
                ex_msg = child.attrib.get('message')
                ex_title = get_exception_title(ex_type, ex_msg)
                body.append(ex_title)
                if child.text is not None:
                    body.append(get_exception_body(child.text))
                if child.tag == 'error':
                    is_error = True
                    ERRORS += 1
                elif child.tag == 'failure':
                    FAILURES += 1
            body = '\n'.join(body)

            if is_error:
                title = get_error(testcase.attrib['name'],
                                  testcase.attrib['time'])
                ex_id = 'error%s' % ERRORS
            else:
                title = get_fail(testcase.attrib['name'],
                                 testcase.attrib['time'])
                ex_id = 'failure%s' % FAILURES

            print_exception(ex_id, title, body)
            EXCEPTIONS.setdefault(class_name, []).append(
                ('summary%s_%s' % (index, ex_id), title, body))
        else:
            print_success(testcase.attrib['name'], testcase.attrib['time'])
        TESTS += 1


def prettify(directory):
    global EXCEPTIONS, TIME

    for index, file_path in enumerate(glob.glob('%s/*.xml' % directory)):
        print ''

        try:
            suite = et.parse(file_path).getroot()
        except et.ParseError:
            print_error('%s cannot be parsed.' % file_path)
            continue

        print_separator(ANSI_BLUE_BOLD)
        print get_title(suite.attrib['name'], suite.attrib['tests'],
                        suite.attrib['failures'], suite.attrib['errors'],
                        suite.attrib['time'])
        try:
            TIME += float(suite.attrib['time'])
        except ValueError:
            print_error('%s cannot be parsed.' % suite.attrib['time'])

        print_separator(ANSI_BLUE_BOLD)

        class_names = set()
        for testcase in suite.findall('testcase'):
            class_names.add(testcase.attrib['classname'])

        for class_name in class_names:
            print ''
            if class_name != '':
                print_bold(class_name)
            prettify_class_name(suite, class_name, index + 1)

        print ''
        print_summary(index + 1)
        EXCEPTIONS = {}  # Reset for next file
        print ''
    if build_failed():
        sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print 'This program expects one parameter.'
        sys.exit(1)

    prettify(sys.argv[1])
