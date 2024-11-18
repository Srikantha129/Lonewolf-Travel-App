import 'package:permission_handler/permission_handler.dart';

// Check if location permission is granted
Future<void> checkLocationPermission() async {
  PermissionStatus status = await Permission.location.status;

  if (!status.isGranted) {
    // If permission is not granted, request it
    PermissionStatus newStatus = await Permission.location.request();
    if (newStatus.isGranted) {
      print('Location permission granted');
      // Proceed with location-related tasks
    } else {
      print('Location permission denied');
      // Handle permission denial
    }
  } else {
    // Permission is already granted
    print('Location permission already granted');
    // Proceed with location-related tasks
  }
}
