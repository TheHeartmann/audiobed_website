'''
A file containing various shared elements for the commit hooks.
'''

SEPARATOR = '=' * 60


def start_hook(message):
    print('{}\n\n{}'.format(SEPARATOR, message))


def end_hook(message):
    print('{}\n\n{}'.format(message, SEPARATOR))
