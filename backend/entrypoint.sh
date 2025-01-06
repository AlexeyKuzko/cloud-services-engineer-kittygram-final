#!/bin/bash

echo "Collecting static"
python manage.py collectstatic --noinput || exit 1

echo "Migrating database"
python manage.py migrate || exit 1

echo "Running server"
python manage.py runserver 0.0.0.0:8000