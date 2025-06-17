#!/bin/bash

# Coolify Deployment Script for Postiz
# This script helps set up environment variables for Coolify deployment

echo "🚀 Postiz Coolify Deployment Helper"
echo "======================================"

# Function to generate a secure JWT secret
generate_jwt_secret() {
    openssl rand -base64 64 | tr -d "=+/" | cut -c1-64
}

# Function to generate a secure password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-24
}

echo ""
echo "📋 Required Environment Variables for Coolify:"
echo ""

# Generate secure values
JWT_SECRET=$(generate_jwt_secret)
DB_PASSWORD=$(generate_password)

echo "# Database Configuration"
echo "DATABASE_URL=postgresql://postiz:${DB_PASSWORD}@postgres:5432/postiz"
echo "POSTGRES_DB=postiz"
echo "POSTGRES_USER=postiz"
echo "POSTGRES_PASSWORD=${DB_PASSWORD}"
echo ""

echo "# Redis Configuration"
echo "REDIS_URL=redis://redis:6379"
echo ""

echo "# Security"
echo "JWT_SECRET=${JWT_SECRET}"
echo ""

echo "# URLs (REPLACE WITH YOUR DOMAIN)"
echo "FRONTEND_URL=https://your-domain.com"
echo "NEXT_PUBLIC_BACKEND_URL=https://your-domain.com/api"
echo "BACKEND_INTERNAL_URL=http://app:3000"
echo ""

echo "# Cloudflare R2 (REPLACE WITH YOUR VALUES)"
echo "CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id"
echo "CLOUDFLARE_ACCESS_KEY=your_r2_access_key"
echo "CLOUDFLARE_SECRET_ACCESS_KEY=your_r2_secret_key"
echo "CLOUDFLARE_BUCKETNAME=your_bucket_name"
echo "CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com"
echo "CLOUDFLARE_REGION=auto"
echo ""

echo "# Application Settings"
echo "STORAGE_PROVIDER=cloudflare"
echo "IS_GENERAL=true"
echo "NODE_ENV=production"
echo "API_LIMIT=30"
echo "NX_ADD_PLUGINS=false"
echo ""

echo "📌 Next Steps:"
echo "1. Copy the above environment variables to your Coolify resource"
echo "2. Replace 'your-domain.com' with your actual domain"
echo "3. Replace Cloudflare R2 credentials with your actual values"
echo "4. Deploy using the docker-compose.yml file"
echo ""
echo "📖 For detailed instructions, see COOLIFY_DEPLOYMENT.md"
