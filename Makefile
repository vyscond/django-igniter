setup:
	virtualenv -p python3 env
	source env/bin/activate &&\
	pip install django &&\
	python manage.py createsuperuser --username vyscond --email vyscond@gmail.com

run: # make run ENV=something
ifeq ($(ENV),production)
	DJANGO_SETTINGS_MODULE=cfg.production python manage.py runserver 0.0.0.0:8000
else ifeq ($(ENV),stage)
	DJANGO_SETTINGS_MODULE=cfg.stage python manage.py runserver 0.0.0.0:8000
else ifeq ($(ENV),development)
	DJANGO_SETTINGS_MODULE=cfg.development python manage.py runserver 0.0.0.0:8000
else
	python manage.py runserver 0.0.0.0:8000
endif
