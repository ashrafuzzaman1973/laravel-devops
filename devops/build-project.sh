#!/bin/bash

set -e  # কোনো command fail করলে script stop হবে

echo "🚀 Building Laravel project..."

# ENV setup
echo "⚙️ Setting up environment..."
if [ -f .env.pipelines ]; then
  ln -sf .env.pipelines .env
else
  echo "⚠️ .env.pipelines not found, using .env.example"
  cp .env.example .env
fi

# Install PHP dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Install JS dependencies (clean install for CI stability)
echo "📦 Installing NPM dependencies..."
rm -rf node_modules package-lock.json
npm install --no-optional

# Laravel setup
echo "⚙️ Laravel setup..."
php artisan key:generate --force
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Wait for MySQL (retry instead of fixed sleep)
echo "⏳ Waiting for MySQL..."
until php -r "
try {
    new PDO('mysql:host=127.0.0.1;dbname=homestead', 'homestead', 'secret');
    echo 'DB connected';
} catch (Exception \$e) {
    exit(1);
}
"; do
  echo "Waiting for database..."
  sleep 3
done

# Run migrations
echo "🗄️ Running migrations..."
php artisan migrate --force

# Build frontend (Vite)
echo "🏗️ Building frontend..."
npm run build

# Run tests
echo "🧪 Running tests..."
php artisan test --parallel || php artisan test

echo "✅ Project build completed successfully!"
