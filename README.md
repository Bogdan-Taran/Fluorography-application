# Инструкции по запуску
Для первого запуска скопируйте в терминал следующее:
```shell
git clone https://github.com/tomtit-tomsk/flura.git
cd flura/backend
cp .env.example .env # Если будет необходимо внести изменения в окружение, редактируйте файл .env (Не .env-example)!
cd ../deploy/prod
ln -s ../backend/.env .env
docker compose up -d --build
docker exec backend php artisan key:generate
docker exec backend php artisan migrate
```

Для заполнения БД тестовыми данными необходимо ввести следующую команду:
```shell
docker exec backend php artisan db:seed
```

Для всех последующих запусков достаточно скопировать в терминал следующее:
```shell
cd flura/deploy/prod
docker compose up -d
```


