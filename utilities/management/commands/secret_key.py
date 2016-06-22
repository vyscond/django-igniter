from django.core.management.base import BaseCommand, CommandError
from django.utils.crypto import get_random_string


class Command(BaseCommand):
    help = 'Generates a new secret key'

    def handle(self, *args, **options):
        chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'
        msg = 'your new SECRET_KEY "{}"'.format(get_random_string(50, chars))
        self.stdout.write(self.style.SUCCESS(msg))
