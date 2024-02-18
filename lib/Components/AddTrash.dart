import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Necessary for JSON encoding

class AddTrash extends StatelessWidget {
  final Function(LatLng)? onSave;

  const AddTrash({Key? key, this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTrashScreen(
              onSave: onSave,
            ),
          ),
        );
      },
      child: const Icon(Icons.add, color: Colors.black),
      backgroundColor: Colors.white,
    );
  }
}

class AddTrashScreen extends StatefulWidget {
  final Function(LatLng)? onSave;

  const AddTrashScreen({Key? key, this.onSave}) : super(key: key);

  @override
  _AddTrashScreenState createState() => _AddTrashScreenState();
}

class _AddTrashScreenState extends State<AddTrashScreen> {
  LatLng? _markerPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trash'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // San Francisco
              zoom: 15.0,
            ),
            onTap: _handleTap,
            markers: _markerPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId('new_marker'),
                      position: _markerPosition!,
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: _markerPosition != null
                  ? Text(
                      'Latitude: ${_markerPosition!.latitude.toStringAsFixed(6)}, Longitude: ${_markerPosition!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : const Text(
                      'Tap on the map to place a marker',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
          Positioned(
            bottom: 20 + 16, // Adjusted bottom position for the buttons
            left: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveMarker,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      _markerPosition = tappedPoint;
    });
  }

  Future<void> _saveMarker() async {
    if (_markerPosition != null) {
      var url = Uri.parse('http://localhost:3000/post'); // Adjust this URL to your server's address
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': 'Trash Point', // You might want to dynamically name these or include other identifying information
          'latitude': _markerPosition!.latitude,
          'longitude': _markerPosition!.longitude,
        }),
      );

      if (response.statusCode == 201) {
        print('Trash point added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trash point added successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        print('Failed to add trash point. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add trash point. Please try again.')),
        );
      }
    } else {
      print('Error: No location selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first.')),
      );
    }
  }
}
