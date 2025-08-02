# TouchGrass CI/CD Workflows

This directory contains GitHub Actions workflows for the TouchGrass project's continuous integration and deployment pipeline.

## 📋 Workflows Overview

### 🔄 `ci.yml` - Main CI/CD Pipeline
**Triggers**: Push/PR to `main` or `develop` branches

**Jobs**:
- **Flutter Tests**: Formatting, analysis, widget tests with coverage
- **Next.js Tests**: ESLint, build verification
- **Security Scan**: Snyk vulnerability scanning
- **Supabase Check**: Migration file validation
- **Flutter Build**: Production web build (main branch only)
- **Deploy Production**: Cloudflare Pages deployment (main branch only)
- **Health Check**: Post-deployment verification

### 🚀 `deploy-staging.yml` - Staging Deployment
**Triggers**: Push to `develop` branch, manual dispatch

**Features**:
- Quick test run before deployment
- Staging environment deployment
- PR comments with staging URLs

### 🔧 `dependency-updates.yml` - Automated Updates
**Triggers**: Weekly schedule (Mondays 9 AM UTC), manual dispatch

**Features**:
- Automated Flutter dependency updates
- Automated Node.js dependency updates  
- Security patch application
- Automated PR creation

## 🔐 Required GitHub Secrets

Add these secrets in your repository settings (`Settings` → `Secrets and variables` → `Actions`):

### Production Supabase
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Staging Supabase (Optional)
```
STAGING_SUPABASE_URL=https://your-staging-project.supabase.co
STAGING_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Cloudflare Pages
```
CLOUDFLARE_API_TOKEN=your_cloudflare_api_token
CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id
```

### Security Scanning (Optional)
```
SNYK_TOKEN=your_snyk_token
```

### Next.js Environment (for builds)
```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 🛠️ Setup Instructions

### 1. Configure GitHub Secrets
1. Go to your repository on GitHub
2. Navigate to `Settings` → `Secrets and variables` → `Actions`
3. Click `New repository secret`
4. Add each secret from the list above

### 2. Configure Cloudflare Pages
1. Create a Cloudflare account and add your domain
2. Get your API token from Cloudflare dashboard
3. Create projects named `touchgrass-app` (production) and `touchgrass-staging` (staging)
4. Add the Cloudflare secrets to GitHub

### 3. Configure Supabase
1. Make sure your production Supabase project is set up
2. Optionally create a staging Supabase project
3. Add the Supabase URLs and anon keys as secrets

### 4. Enable Workflows
1. Workflows will automatically run on the next push to `main` or `develop`
2. Check the `Actions` tab in your repository to monitor progress

## 📊 Workflow Status Badges

Add these to your main README.md:

```markdown
[![CI/CD](https://github.com/your-username/touchgrassapp/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/touchgrassapp/actions/workflows/ci.yml)
[![Deploy Staging](https://github.com/your-username/touchgrassapp/actions/workflows/deploy-staging.yml/badge.svg)](https://github.com/your-username/touchgrassapp/actions/workflows/deploy-staging.yml)
```

## 🚨 Troubleshooting

### Common Issues

1. **Flutter build fails**: Check that all dependencies in `flutter_app/pubspec.yaml` are compatible
2. **Cloudflare deployment fails**: Verify API token permissions and project names
3. **Supabase connection fails**: Ensure URLs and keys are correctly formatted
4. **Security scan fails**: Review Snyk findings and update vulnerable packages

### Debug Steps

1. Check the `Actions` tab for detailed error logs
2. Verify all required secrets are set
3. Test builds locally before pushing
4. Review Flutter and Node.js versions in workflows

## 📈 Performance & Monitoring

- **Build times**: Typically 3-5 minutes for Flutter web builds
- **Test coverage**: Tracked via Codecov integration
- **Security**: Weekly dependency scans and updates
- **Health checks**: Automated post-deployment verification

## 🔄 Maintenance

- Workflows are automatically updated via Dependabot
- Flutter and Node.js versions are pinned for stability
- Security scans run on every PR and weekly schedule
- Dependencies are updated weekly with automated PRs