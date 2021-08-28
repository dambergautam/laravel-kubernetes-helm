#!/bin/bash

# Clean up existing docker data -For clean installation
rm -rf docker/laravel
rm -rf docker/db/dbdata

docker-compose down 

# OPTION 1
# -------------------- #
# Download laravel LTS framework (https://github.com/laravel/laravel/releases)
LARAVEL_VERSION_NO="5.5.28"
curl -L https://github.com/laravel/laravel/archive/v${LARAVEL_VERSION_NO}.tar.gz | tar xz
mv laravel-${LARAVEL_VERSION_NO} docker/laravel
cp docker/laravel/.env.example docker/laravel/.env
# -------------------- #

# OPTION 2
# -------------------- #
# OR clone your existing project
#git clone https://github.com/<laravel-project-repo>.git laravel
#mv laravel docker/laravel

# Checkout develop branch for local development purpose
#cd laravel
#git checkout develop
#cd ..
# -------------------- #

# Create image
docker-compose up --build -d

# Perform series of action in container
APP_NAME="laravel_php_fpm"

docker-compose exec $APP_NAME composer install

docker-compose exec $APP_NAME php artisan key:generate

docker-compose exec $APP_NAME node -v

docker-compose exec $APP_NAME npm install

docker-compose exec $APP_NAME npm run dev

# Ensure database is ready to handel php artisan command
sleep 3

docker-compose exec $APP_NAME php artisan optimize

docker-compose exec $APP_NAME php artisan migrate

docker-compose exec $APP_NAME vendor/bin/phpunit