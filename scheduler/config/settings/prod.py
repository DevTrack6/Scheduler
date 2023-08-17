from .base import *

DEBUG = False

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = [
    os.getenv("SERVER_IP"),
]
