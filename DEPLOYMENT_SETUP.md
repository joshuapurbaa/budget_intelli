# Automatic Deployment Setup Guide

This guide will help you set up automatic deployment for your Flutter app to Google Play Store using GitHub Actions.

## Prerequisites

1. **Flutter app already published to Play Store** ✅ (You have this)
2. **GitHub repository** ✅ (You have this)
3. **Google Play Console access** ✅ (You have this)
4. **Google Cloud Platform account**

## Step 1: Create Google Cloud Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **Google Play Android Developer API**
4. Go to **IAM & Admin** → **Service Accounts**
5. Click **Create Service Account**
6. Give it a name like `play-store-deploy`
7. Click **Create and Continue**
8. Skip role assignment for now
9. Click **Done**
10. Click on the created service account
11. Go to **Keys** tab
12. Click **Add Key** → **Create new key** → **JSON**
13. Download the JSON file

## Step 2: Configure Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Go to **Setup** → **API access**
3. Link your Google Cloud project (if not already linked)
4. Grant access to the service account:
   - Find your service account email
   - Click **Grant Access**
   - Choose **Admin (all permissions)** or create custom role with:
     - View app information and download bulk reports
     - View and edit store listing, pricing & distribution
     - Manage production APKs
     - Manage testing APKs

## Step 3: Prepare Android Signing

### Generate Upload Keystore (if you don't have one)
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### If you already have a keystore:
- Make sure you have your keystore file
- Note down the keystore password, key password, and key alias

## Step 4: Configure GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**

Add these secrets:

### Required Secrets:
1. **GOOGLE_SERVICE_ACCOUNT_JSON**: 
   - Base64 encode your service account JSON file:
   ```bash
   base64 -i path/to/your/service-account.json | pbcopy
   ```
   - Paste the result

2. **ANDROID_KEYSTORE_BASE64**:
   - Base64 encode your keystore file:
   ```bash
   base64 -i path/to/your/upload-keystore.jks | pbcopy
   ```
   - Paste the result

3. **ANDROID_KEYSTORE_PASSWORD**: Your keystore password
4. **ANDROID_KEY_PASSWORD**: Your key password  
5. **ANDROID_KEY_ALIAS**: Your key alias (usually "upload")

## Step 5: Test the Setup

1. Make a small change to your app
2. Commit and push to main branch
3. Check GitHub Actions tab for the workflow run
4. If successful, check Google Play Console for the new build

## Step 6: Deployment Tracks

The workflow is set to deploy to **internal** track by default. You can change this in `.github/workflows/deploy.yml`:

- `internal`: Internal testing
- `alpha`: Alpha testing  
- `beta`: Beta testing
- `production`: Production (live)

## Step 7: Version Management

Update your `pubspec.yaml` version before each release:
```yaml
version: 1.2.1+79  # 1.2.1 is version name, 79 is version code
```

## Troubleshooting

### Common Issues:

1. **"The Android App Bundle was not signed"**
   - Check your keystore configuration
   - Ensure secrets are properly set

2. **"Package not found"**
   - Verify the package name in the workflow matches your app
   - Check service account permissions

3. **"Version code X has already been used"**
   - Increment the version code in pubspec.yaml

4. **"APK not found"**
   - The workflow builds an AAB (App Bundle) not APK
   - This is recommended by Google

## Advanced Features

### Conditional Deployment
You can modify the workflow to only deploy on specific conditions:
- Only on tags/releases
- Only from specific branches
- Only with specific commit messages

### Multiple Tracks
You can create separate workflows for different tracks (internal, beta, production).

### Notifications
Add Slack/Discord notifications for successful/failed deployments.

## Security Notes

- Never commit keystores or sensitive files to your repository
- Use GitHub Secrets for all sensitive information
- Regularly rotate your service account keys
- Use the principle of least privilege for service account permissions

## Manual Deployment

You can still deploy manually using:
```bash
flutter build appbundle --release
```
Then upload the AAB file to Play Console manually.

## Need Help?

1. Check GitHub Actions logs for detailed error messages
2. Verify all secrets are properly configured
3. Ensure your service account has the correct permissions
4. Test with internal track first before production

---

**Note**: The first deployment after setting this up should be to internal track to test everything works correctly. 