
ifeq ($(shell uname -s), Darwin) # OSX only
	export PATH := /Applications/Postgres.app/Contents/Versions/9.4/bin:$(PATH)
endif

ifneq ($(env),)
	export DJANGO_SETTINGS_MODULE=cfg.$(env)
endif

VIRTUAL_ENV = env
python = $(VIRTUAL_ENV)/bin/python
wsgi = $(VIRTUAL_ENV)/bin/gunicorn

setup:
	
ifeq ($(shell which pyvenv),)
	virtualenv -p python3 $(VIRTUAL_ENV)
else
	pyvenv env
endif
	
	$(eval username ?= vyscond)
	$(eval email ?= vyscond@gmail.com)
	
	source env/bin/activate && \
	pip install django && \
	python manage.py migrate && \
	python manage.py createsuperuser --username $(username) --email $(email)

shell:
	$(python) manage.py shell

run: # make run ENV=something
	$(python) manage.py runserver 0.0.0.0:8000

wsgi:
	$(wsgi) cfg.wsgi --log-file -
