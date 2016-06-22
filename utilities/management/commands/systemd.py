from django.core.management.base import BaseCommand
# from django.core.management.base import CommandError
from django.conf import settings


class Command(BaseCommand):
    help = 'Generates a new secret key'

    def add_arguments(self, parser):
        # Named (optional) arguments
        parser.add_argument(
            '--project-name',
            default=False,
            help='Delete poll instead of closing it',
        )

    def handle(self, *args, **options):
        # self.stdout.write(self.style.SUCCESS('Generating systemd'))
        try:
            print(settings.get('chimichangas', None))
            if options['project_name']:
                project_name = options['project_name']
                project_name_normalized = project_name.lower().replace(' ', '_')
            output = ''
            for section in settings.SYSTEMD:
                output += '[{}]\n'.format(section)
                for subsection in settings.SYSTEMD[section]:
                    if subsection == 'Environment':
                        for env in settings.SYSTEMD[section]['Environment']:
                            output += 'Environment={}={}\n'.format(
                                env, settings.SYSTEMD[section]['Environment'][env])
                    else:
                        output += '{}={}\n'.format(
                            subsection, settings.SYSTEMD[section][subsection])
                output += '\n'
            print(output)
        except AttributeError as e:
            self.stdout.write(self.style.ERROR(str(e)))
