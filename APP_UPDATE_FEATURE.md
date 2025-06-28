# In-App Update Feature for Budget Intelli

## Overview

This feature implements in-app updates for Budget Intelli that shows a popup when a new version is available on the Play Store. Users can update the app without leaving it, providing a seamless user experience.

## Features

### Android (Google Play)
- ✅ **Flexible Updates**: Download in background, install when convenient
- ✅ **Immediate Updates**: Force immediate update for critical versions
- ✅ **Native Google Play Integration**: Uses Google Play's official in-app update API
- ✅ **Download Progress**: Shows download progress and completion status
- ✅ **Smart Caching**: Checks for updates every 6 hours to avoid excessive API calls

### iOS (App Store)
- ✅ **App Store Redirect**: Opens App Store for manual update
- ✅ **Version Check Ready**: Framework ready for server-side version checking

## How It Works

### 1. Update Service (`UpdateService`)
- Singleton service that handles all update operations
- Checks for updates using Google Play's in-app update API (Android)
- Caches results for 6 hours to prevent excessive checks
- Provides methods for flexible and immediate updates

### 2. State Management (`AppUpdateCubit`)
- Manages update states using BLoC pattern
- Handles update checking, downloading, and installation states
- Provides error handling and user feedback

### 3. UI Components (`AppUpdateDialog`)
- Beautiful, localized dialog that shows update information
- Different options based on update type (flexible/immediate)
- Progress indicators during download and installation
- Handles user interactions (Update Now, Later, Restart)

### 4. Integration
- Automatically checks for updates on app startup
- Shows dialog when update is available
- Integrated into main app lifecycle

## Implementation Details

### Files Added/Modified

#### New Files:
- `lib/core/services/update_service.dart` - Core update functionality
- `lib/core/global_controller/app_update/app_update_cubit.dart` - State management
- `lib/core/global_controller/app_update/app_update_state.dart` - Update states
- `lib/core/widgets/app_update_dialog.dart` - Update UI dialog

#### Modified Files:
- `pubspec.yaml` - Added dependencies
- `lib/main.dart` - Added AppUpdateCubit provider
- `lib/budget_intelli.dart` - Integrated update checking
- `lib/core/l10n/app_en.arb` - Added English strings
- `lib/core/l10n/app_id.arb` - Added Indonesian strings
- `lib/core/core.dart` - Added exports

#### Dependencies Added:
- `in_app_update: ^4.2.3` - Google Play in-app updates
- `upgrader: ^11.1.0` - Cross-platform version checking (future use)
- `package_info_plus: ^8.0.2` - App version information

## Testing the Feature

### 1. Development Testing

Since in-app updates only work with apps distributed through Google Play, testing requires special setup:

#### Option A: Use Google Play Console (Recommended)
1. Upload your app to Google Play Console (Internal Testing track)
2. Install the app from Play Store
3. Upload a new version with higher version code
4. Test the update flow

#### Option B: Test Individual Components
```dart
// Test update checking
context.read<AppUpdateCubit>().checkForUpdates();

// Manually trigger update dialog (for testing UI)
AppUpdateDialog.show(context, mockUpdateInfo);

// Clear cache to force fresh check
context.read<AppUpdateCubit>().clearCacheAndCheck();
```

### 2. Production Testing

1. **Deploy to Internal Testing**: Upload to Google Play Console internal testing track
2. **Install from Play Store**: Install the app from Play Store (not via development)
3. **Upload New Version**: Upload a new version with higher version code
4. **Test Update Flow**: Open the app and verify update dialog appears

## Customization Options

### 1. Update Check Frequency
```dart
// In UpdateService class, modify the check interval:
static const Duration _checkInterval = Duration(hours: 6); // Change as needed
```

### 2. Update Dialog Behavior
```dart
// Force immediate updates for critical versions
AppUpdateDialog.show(
  context, 
  updateInfo,
  canDismiss: false, // Prevent dismissing for critical updates
);
```

### 3. Update Trigger Points
Currently triggers on app startup. You can add additional trigger points:

```dart
// Manual check in settings
context.read<AppUpdateCubit>().clearCacheAndCheck();

// Periodic check during app usage
Timer.periodic(Duration(hours: 24), (timer) {
  context.read<AppUpdateCubit>().checkForUpdates();
});
```

### 4. iOS App Store URL
Update the iOS App Store URL in `UpdateService`:
```dart
// Replace YOUR_APP_ID with actual App Store ID
const url = 'https://apps.apple.com/app/budget-intelli/idYOUR_APP_ID';
```

## Localization

The feature includes full localization support:

### English Strings:
- `updateAvailable`: "Update Available"
- `newVersionAvailable`: "A new version of Budget Intelli is available!"
- `currentVersion`: "Current Version"
- `newVersion`: "New Version"
- `updateRecommendation`: "We recommend updating to get the latest features and improvements."
- `later`: "Later"
- `updateNow`: "Update Now"
- `updateDownloaded`: "Update Downloaded"
- `restartToComplete`: "Restart the app to complete the update."
- `restartNow`: "Restart Now"

### Indonesian Strings:
- `updateAvailable`: "Update Tersedia"
- `newVersionAvailable`: "Versi baru Budget Intelli telah tersedia!"
- And more...

## Best Practices

### 1. Update Strategy
- **Flexible Updates**: Use for regular feature updates
- **Immediate Updates**: Use only for critical security fixes
- **User Choice**: Always allow users to postpone non-critical updates

### 2. Testing Strategy
- Test on both Play Store and development environments
- Test with different network conditions
- Test update cancellation and retry scenarios

### 3. User Experience
- Show clear benefits of updating
- Minimize interruption to user workflow
- Provide progress feedback during download
- Handle errors gracefully

## Monitoring and Analytics

Consider adding analytics to track:
- Update check frequency
- Update acceptance rate
- Update completion rate
- Error rates and types

## Troubleshooting

### Common Issues:

1. **Updates Not Detected**
   - Ensure app is installed from Play Store
   - Check version code is properly incremented
   - Verify Play Store has processed the new version

2. **Update Dialog Not Showing**
   - Check if update was dismissed recently
   - Verify BlocListener is properly set up
   - Check logs for any errors

3. **Update Failed**
   - Check device storage space
   - Verify network connectivity
   - Check Google Play services status

### Debug Commands:
```dart
// Enable debug logging
UpdateService().clearCache(); // Force fresh check
context.read<AppUpdateCubit>().checkForUpdates();
```

## Future Enhancements

1. **Server-Side Version Check**: Implement backend API for iOS version checking
2. **Update Scheduling**: Allow users to schedule updates for specific times
3. **Progressive Updates**: Support for incremental updates
4. **A/B Testing**: Test different update prompts and strategies
5. **Offline Update**: Cache updates for installation when online

---

**Note**: This feature primarily works on Android with Google Play Store. For iOS, it currently redirects to the App Store, but can be enhanced with server-side version checking for more sophisticated iOS update handling. 