import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
              onSave: onSave ?? (LatLng position) {
                print('Saved position: $position');
              },
            ),
          ),
        );
      },
      child: Icon(Icons.add),
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
        title: Text('Add Trash'),
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
                      markerId: MarkerId('new_marker'),
                      position: _markerPosition!,
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: _markerPosition != null
                  ? Text(
                      'Latitude: ${_markerPosition!.latitude.toStringAsFixed(6)}, Longitude: ${_markerPosition!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 16),
                    )
                  : Text(
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
                  icon: Icon(Icons.save),
                  onPressed: () {
                    _saveMarker();
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close),
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

  void _saveMarker() {
    if (_markerPosition != null && widget.onSave != null) {
      widget.onSave!(_markerPosition!);
      print('Coordinates saved: ${_markerPosition!.latitude}, ${_markerPosition!.longitude}');
    } else {
      print('Error: Marker position is null or onSave function is null');
    }
  }
}
