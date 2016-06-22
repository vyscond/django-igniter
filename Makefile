ifeq ($(shell uname -s), Darwin) # OSX only
	export PATH := /Applications/Postgres.app/Contents/Versions/9.4/bin:$(PATH)
endif

ifneq ($(env),)
	export DJANGO_SETTINGS_MODULE=cfg.$(env)
endif

# - Virtual Environment Commands
VIRTUAL_ENV = env
python = $(VIRTUAL_ENV)/bin/python
wsgi = $(VIRTUAL_ENV)/bin/gunicorn
lint = $(VIRTUAL_ENV)/bin/flake8

# - Requirements
REQUIREMENTS = requirements
COMMON = $(REQUIREMENTS)/common.txt
DEVELOPMENT = $(REQUIREMENTS)/development.txt

setup:

ifeq ($(shell which pyvenv),)
	virtualenv -p python3 $(VIRTUAL_ENV)
else
	pyvenv env
endif

ifeq ($(env),'development')
	@echo 'setup development'
	$(eval username ?= vyscond)
	$(eval email ?= vyscond@gmail.com)

	source env/bin/activate && \
	pip install pip --upgrade && \
	pip install -r $(COMMON) && \
	pip install -r $(DEVELOPMENT) && \
	python manage.py migrate && \
	echo 'Password to new superuser' && \
	python manage.py createsuperuser --username $(username) --email $(email)
else ifeq($(env),'production')
	@echo 'setup production'
endif

lint:
	$(lint) $(app)

manage:
	$(python) manage.py $(cmd)

shell:
	$(python) manage.py shell

run:
	$(python) manage.py runserver 0.0.0.0:8000

wsgi:
	$(wsgi) cfg.wsgi --log-file -
