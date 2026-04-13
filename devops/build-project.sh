#!/bin/bash

echo "🚀 Building Laravel project..."

# Here we create link between the .env.pipelines file and the .env file.
ln -f -s .env.pipelines .env

# Install PHP dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Install JS dependencies
echo "📦 Installing NPM dependencies..."
npm install

# Laravel setup
echo "⚙️ Laravel setup..."
php artisan key:generate
php artisan config:clear
php artisan cache:clear

# Wait for MySQL
echo "⏳ Waiting for MySQL..."
sleep 10

# Run migrations
php artisan migrate --force

# Build frontend (Vite)
echo "🏗️ Building frontend..."
npm run build

# Run tests (optional)
echo "🧪 Running tests..."
php artisan test

echo "✅ Project build completed!"
