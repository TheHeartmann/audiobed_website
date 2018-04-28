'''
A file containing various shared elements for the commit hooks.
'''

SEPARATOR = '=' * 60


def start_hook(message):
    print_message('{}\n\n{}'.format(SEPARATOR, message))


def end_hook(message):
    print_message('{}\n\n{}'.format(message, SEPARATOR))


def print_message(message):
    print('{}\n'.format(message))
