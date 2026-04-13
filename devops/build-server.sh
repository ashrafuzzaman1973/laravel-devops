#!/bin/bash

echo "🚀 Setting up server environment..."

# Update packages
apt-get update

# Install system dependencies
apt-get install -y \
    git unzip curl zip \
    libpng-dev libonig-dev libxml2-dev libzip-dev

# Install PHP extensions
docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
if ! command -v composer &> /dev/null
then
    echo "📦 Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# Install Node.js (v18)
echo "📦 Installing Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

# Check versions
php -v
composer -V
node -v
npm -v

echo "✅ Server setup completed!"
