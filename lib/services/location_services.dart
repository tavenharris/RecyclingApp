import 'package:location/location.dart';
import 'dart:async'; // Import required for StreamSubscription

class LocationService {
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription; // Declare the subscription

  LocationService() {
    location.changeSettings(
      accuracy: LocationAccuracy.high, // Use high accuracy location
      interval: 1000, // Update every second, adjust to your needs
      distanceFilter: 0, // Update at every movement
    );
  }

  Future<LocationData?> locateUser() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Request service if not enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Request permission if not granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    try {
      // Get the location
      return await location.getLocation();
    } catch (e) {
      print('Could not get the location: $e');
      return null;
    }
  }

  void listenToLocationChanges(Function(LocationData) onLocationChanged) {
    locationSubscription = location.onLocationChanged.listen(onLocationChanged);
  }

  void cancelLocationSubscription() {
    locationSubscription?.cancel();
  }
}
