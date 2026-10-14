from pathlib import Path

# Carpeta donde se encuentra manage.py.
BASE_DIR = Path(__file__).resolve().parent.parent

# Configuración para desarrollo local.
SECRET_KEY = 'django-insecure-+g&fp5^g%%_d@2s6uix9c%^xwynuog(*p*rneu0ximn&3%uks8'

DEBUG = True

ALLOWED_HOSTS = ["127.0.0.1", "localhost"]


# Aplicaciones instaladas.
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "fichadas",
]


# Componentes que procesan las solicitudes.
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]


# Rutas principales.
ROOT_URLCONF = "reloj.urls"


# Plantillas HTML.
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]


WSGI_APPLICATION = "reloj.wsgi.application"


# Conexión a MySQL.
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "proyectointegrador",
        "USER": "root",
        "PASSWORD": "Micherio2026",
        "HOST": "127.0.0.1",
        "PORT": "3308",
    }
}


# Validación de contraseñas de usuarios de Django.
AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": (
            "django.contrib.auth.password_validation."
            "UserAttributeSimilarityValidator"
        ),
    },
    {
        "NAME": (
            "django.contrib.auth.password_validation."
            "MinimumLengthValidator"
        ),
    },
    {
        "NAME": (
            "django.contrib.auth.password_validation."
            "CommonPasswordValidator"
        ),
    },
    {
        "NAME": (
            "django.contrib.auth.password_validation."
            "NumericPasswordValidator"
        ),
    },
]


# Idioma y zona horaria de Uruguay.
LANGUAGE_CODE = "es"

TIME_ZONE = "America/Montevideo"

USE_I18N = True

USE_TZ = True


# Archivos estáticos: CSS y JavaScript.
STATIC_URL = "static/"


# Correo de desarrollo: muestra los mensajes en la terminal.
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"


# Identificadores automáticos de los modelos.
DEFAULT_AUTO_FIELD = "django.db.models.AutoField"