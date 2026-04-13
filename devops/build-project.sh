#!/bin/bash

set -e  # কোনো command fail করলে script stop হবে

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
# 🔥 VERY IMPORTANT (Fix cache issue)
# ==============================
echo "🧹 Clearing Laravel cache..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

# ==============================
# Install PHP dependencies
# ==============================
echo "📦 Installing Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# ==============================
# Install JS dependencies (stable)
# ==============================
echo "📦 Installing NPM dependencies..."
rm -rf node_modules package-lock.json
npm install --no-optional

# ==============================
# Laravel setup
# ==============================
echo "⚙️ Laravel setup..."
php artisan key:generate --force

# আবার config clear (env নিশ্চিতভাবে apply করার জন্য)
php artisan config:clear

# ==============================
# Wait for MySQL (real check)
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
# DB migrations
# ==============================
echo "🗄️ Running migrations..."
php artisan migrate --force

# ==============================
# Frontend build (Vite)
# ==============================
echo "🏗️ Building frontend..."
npm run build

# ==============================
# Run tests
# ==============================
echo "🧪 Running tests..."
php artisan test --parallel || php artisan test

echo "✅ Project build completed successfully!"
