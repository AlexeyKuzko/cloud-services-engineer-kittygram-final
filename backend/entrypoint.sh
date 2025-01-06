#!/bin/bash

echo "Current directory contents: $(ls -la)"

echo "collectstatic"
python manage.py collectstatic --noinput || exit 1

echo "migrate"
python manage.py migrate || exit 1

echo "runserver"
python manage.py runserver 0.0.0.0:8000