# Coolify Configuration for Postiz

## Overview
This document provides step-by-step instructions for deploying Postiz to Coolify.

## Prerequisites
1. Coolify instance running
2. Domain name pointing to your Coolify server
3. (Optional) Resend account for email functionality

## Deployment Steps

### 1. Create a New Resource in Coolify

1. Login to your Coolify dashboard
2. Create a new **Docker Compose** resource
3. Choose your server and destination

### 2. Repository Configuration

1. **Source Type**: Git Repository
2. **Repository URL**: `https://github.com/gitroomhq/postiz-app.git` (or your fork)
3. **Branch**: `main`
4. **Build Pack**: Docker Compose

### 3. Environment Variables

Configure the following environment variables in Coolify:

#### Required Variables:
```
DATABASE_URL=postgresql://postiz:SECURE_PASSWORD@postgres:5432/postiz
POSTGRES_DB=postiz
POSTGRES_USER=postiz
POSTGRES_PASSWORD=SECURE_PASSWORD_HERE
REDIS_URL=redis://redis:6379
JWT_SECRET=VERY_LONG_SECURE_JWT_SECRET_64_CHARS_MINIMUM
FRONTEND_URL=https://your-domain.com
NEXT_PUBLIC_BACKEND_URL=https://your-domain.com/api
BACKEND_INTERNAL_URL=http://app:3000
CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id
CLOUDFLARE_ACCESS_KEY=your_r2_access_key
CLOUDFLARE_SECRET_ACCESS_KEY=your_r2_secret_key
CLOUDFLARE_BUCKETNAME=your_bucket_name
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com
CLOUDFLARE_REGION=auto
STORAGE_PROVIDER=local
UPLOAD_DIRECTORY=/uploads
NEXT_PUBLIC_UPLOAD_STATIC_DIRECTORY=/uploads
IS_GENERAL=true
NODE_ENV=production
API_LIMIT=30
NX_ADD_PLUGINS=false
```

#### Optional Variables:
```
RESEND_API_KEY=your_resend_api_key
EMAIL_FROM_ADDRESS=noreply@your-domain.com
EMAIL_FROM_NAME=Postiz
OPENAI_API_KEY=your_openai_key
```

### 4. Docker Compose Configuration

Coolify will use the `docker-compose.yml` file in the repository. The configuration includes:
- **app**: Main Postiz application (ports: 5000)
- **postgres**: PostgreSQL database
- **redis**: Redis cache

### 5. Domain Configuration

1. In Coolify, go to your resource settings
2. Add your domain in the **Domains** section
3. Enable **HTTPS** (Coolify will handle SSL certificates)
4. Set the port to `5000`

### 6. Storage Configuration

The deployment uses persistent volumes for:
- `postgres_data`: Database storage
- `redis_data`: Redis persistence
- `uploads`: File uploads (if using local storage)

### 7. Health Checks

The configuration includes health checks for all services:
- App: Checks port 5000
- PostgreSQL: Uses pg_isready
- Redis: Uses redis-cli ping

## Post-Deployment Setup

### 1. Database Migration
The application will automatically run database migrations on startup.

### 2. Access the Application
1. Visit `https://your-domain.com`
2. Create your admin account
3. Configure social media integrations

### 3. Configure Social Media APIs
Add API keys for the social platforms you want to use in the environment variables.

## Local Storage Configuration

With local storage enabled, uploaded files are stored in the persistent Docker volume mounted at `/uploads`. This provides:

1. **Persistent storage** across container restarts
2. **Simple backup** through volume snapshots
3. **No external dependencies** for file storage
4. **Direct file serving** from your domain

**Note**: Cloudflare variables are kept in the configuration for potential future migration to external storage if needed.

## Monitoring

Coolify provides built-in monitoring for:
- Container logs
- Resource usage
- Health check status
- Build logs

## Backup Strategy

1. **Database**: Use pg_dump for PostgreSQL backups
2. **Redis**: Redis persistence is enabled
3. **Files**: Backup the Docker volume `uploads` regularly using Coolify's volume backup features

## Troubleshooting

### Common Issues:

1. **Build Failures**: Check build logs in Coolify
2. **Database Connection**: Verify DATABASE_URL format
3. **File Upload Issues**: Check volume mounting and permissions for `/uploads`
4. **Environment Variables**: Ensure all required variables are set
5. **Storage Issues**: Verify `STORAGE_PROVIDER=local` and upload directory paths are correct

### Logs:
- View application logs in Coolify dashboard
- Check individual container logs for specific issues

## Scaling

For high-traffic deployments:
1. Use Coolify's load balancing features
2. Consider external PostgreSQL (managed service)
3. Use Redis Cluster for caching
4. Scale application containers horizontally

## Security Notes

1. Use strong, unique passwords
2. Enable firewall rules
3. Regularly update the application
4. Monitor access logs
5. Use environment-specific API keys
