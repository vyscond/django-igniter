setup:
	virtualenv -p python3 env
	source env/bin/activate && pip install django

run:
	python manage.py runserver 0.0.0.0:8000
