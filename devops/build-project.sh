#!/bin/bash

set -e

echo "🚀 Building Laravel project..."

# ==============================
# ENV setup
# ==============================
echo "⚙️ Setting up environment..."

if [ -f .env.pipelines ]; then
  ln -sf .env.pipelines .env
else
  echo "⚠️ .env.pipelines not found, using .env.example"
  cp .env.example .env
fi

# ==============================
# Laravel cache clear
# ==============================
echo "🧹 Clearing Laravel cache..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

# ==============================
# Composer install
# ==============================
echo "📦 Installing Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# ==============================
# NPM install (FIXED for Vite/Rollup)
# ==============================
echo "📦 Installing NPM dependencies..."

rm -rf node_modules
npm cache clean --force

npm ci --include=optional

# ==============================
# Laravel setup
# ==============================
echo "⚙️ Laravel setup..."
php artisan key:generate --force
php artisan config:clear

# ==============================
# Wait for MySQL
# ==============================
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

# ==============================
# Migrations
# ==============================
echo "🗄️ Running migrations..."
php artisan migrate --force

# ==============================
# Frontend build (Vite)
# ==============================
echo "🏗️ Building frontend..."
npm run build

echo "✅ Project build completed successfully!"
