import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // Import the http package
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
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadTrashBins();
  }
Future<void> _loadTrashBins() async {
  var url = Uri.parse('http://localhost:3000/get');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> fetchedBins = json.decode(response.body);
      setState(() {
        _markers.clear();
        for (var bin in fetchedBins) {
          final double? latitude = bin['latitude'];
          final double? longitude = bin['longitude'];

          if (latitude != null && longitude != null) { // Only add the marker if both values are valid
            final marker = Marker(
              markerId: MarkerId(bin['_id'].toString()), // Convert _id to String
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: bin['name'] ?? 'Unknown'), // Provide a default name if null
            );
            _markers.add(marker);
            print('Marker Added');
          } else {
            print('Skipping bin with invalid location data');
          }
        }
      });
    } else {
      print('Failed to load trash bins from server. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to load trash bins: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.3488, -121.9382), // Initial position, adjust as needed
            zoom: 15.0,
          ),
          markers: _markers,
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: AddTrash(),
        ),
      ],
    );
  }
}
