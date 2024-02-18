import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart'; // Import the location package
import 'AddTrash.dart';

class TrashMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash Map'),
      ),
      body: GoogleMapWidget(),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;
  late Set<Marker> _markers;
  LocationData? _currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _markers = {};
    _getCurrentLocation();
    _loadTrashBins();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await location.getLocation();
      if (_currentLocation != null) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            ),
          );
        });
        _moveCameraToLocation(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
      }
    } catch (e) {
      print('Failed to get current location: $e');
    }
  }

  Future<void> _loadTrashBins() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/get'));
      if (response.statusCode == 200) {
        final List<dynamic> dataArray = json.decode(response.body);
        final trashBins = dataArray.where((dataEntry) =>
            dataEntry['latitude'] != null &&
            dataEntry['longitude'] != null).map((dataEntry) {
          final name = dataEntry['_id'] ?? 'Unknown';
          final latitude = dataEntry['latitude'] as double;
          final longitude = dataEntry['longitude'] as double;
          return TrashBin(name: name, latitude: latitude, longitude: longitude);
        }).toList();

        setState(() {
          _markers.addAll(
            trashBins.map(
              (bin) => Marker(
                markerId: MarkerId(bin.name),
                position: LatLng(bin.latitude, bin.longitude),
              ),
            ),
          );
        });
      } else {
        print('Failed to load trash bins: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load trash bins: $e');
    }
  }

  void _moveCameraToLocation(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: 15),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.3488, -121.9382),
            zoom: 15.0,
          ),
          markers: _markers,
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true, // Enable the my location button
          myLocationButtonEnabled: false, // Hide the default my location button
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: AddTrash(), // Use AddTrash instead of AddTrashButton
        ),
      ],
    );
  }
}

class TrashBin {
  final String name;
  final double latitude;
  final double longitude;

  TrashBin({required this.name, required this.latitude, required this.longitude});
}
