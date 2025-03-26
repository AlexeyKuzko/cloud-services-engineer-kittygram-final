# Kittygram - социальная сеть для любителей котиков

## Описание проекта
Kittygram - это веб-приложение, где пользователи могут делиться фотографиями своих котов, указывать их достижения и особенности.

## Технологии
- Frontend: React
- Backend: Django REST Framework
- База данных: PostgreSQL
- Инфраструктура: Docker, Terraform, Yandex Cloud
- CI/CD: GitHub Actions

## Запуск проекта локально

1. Клонируйте репозиторий:
```bash
git clone <your-repo-url>
cd kittygram
```

2. Создайте файл `.env` в корне проекта:

POSTGRES_USER=kittygram_user
POSTGRES_PASSWORD=kittygram_password
POSTGRES_DB=kittygram
DB_HOST=db
DB_PORT=5432
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

3. Запустите проект через Docker Compose:
```bash
docker compose up -d
```

4. Выполните миграции:
```bash
docker compose exec backend python manage.py migrate
```

## Развертывание в облаке

1. Создайте файл `tests.yml` в корне проекта с вашими данными.

2. Настройте secrets в GitHub:
   - YC_SA_JSON
   - YC_CLOUD_ID
   - YC_FOLDER_ID
   - SSH_KEY
   - ACCESS_KEY
   - SECRET_KEY
   - USER_PASSWORD
   - USER

3. Запустите Terraform:
```bash
cd infra
terraform init
terraform apply
```

## Структура проекта
```
├── backend/         # Django бэкенд
├── frontend/        # React фронтенд
├── infra/          # Terraform конфигурация
└── .github/        # GitHub Actions
├── backend/ # Django бэкенд
├── frontend/ # React фронтенд
├── infra/ # Terraform конфигурация
└── .github/ # GitHub Actions
```

3. **Модульная структура Terraform**
Рекомендую разделить текущую конфигурацию на модули:
infra/
├── modules/
│ ├── network/
│ │ ├── main.tf # VPC, subnet, security group
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── compute/
│ │ ├── main.tf # VM instance
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── storage/
│ ├── main.tf # S3 bucket
│ ├── variables.tf
│ └── outputs.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── provider.tf
4. **Бинарные файлы**
Добавьте в `.gitignore`:

```gitignore
# Terraform
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
*.tfvars
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Binary files
*.jpg
*.jpeg
*.png
*.gif
*.pdf
*.zip
*.tar.gz
```

5. **Тесты**
Для исправления ошибок в тестах нужно увидеть лог ошибки. Рекомендую проверить:
- Доступность всех необходимых портов в security group
- Корректность переменных окружения
- Права доступа к директориям
- Статус сервисов после деплоя

Если вам нужна помощь с конкретной ошибкой тестов, пожалуйста, предоставьте лог ошибки.