import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = {};
    _loadTrashBins();
  }

  Future<void> _loadTrashBins() async {
    try {
      String jsonData = await rootBundle.loadString('assets/poi_data.json');
      Map<String, dynamic> jsonMap = json.decode(jsonData);
      List<dynamic> dataArray = jsonMap['data'];
      List<TrashBin> trashBins = dataArray.map((dataEntry) {
        final entryDetails = dataEntry.last as List;
        final name = dataEntry[8] as String;
        final latitude = double.tryParse(entryDetails[1]) ?? 0.0;
        final longitude = double.tryParse(entryDetails[2]) ?? 0.0;
        return TrashBin(name: name, latitude: latitude, longitude: longitude);
      }).toList();

      setState(() {
        _markers.clear();
        trashBins.forEach((bin) {
          _markers.add(Marker(
            markerId: MarkerId(bin.name),
            position: LatLng(bin.latitude, bin.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Use green trash icon
          ));
        });
      });
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
            target: LatLng(37.3488, -121.9382),
            zoom: 15.0,
          ),
          markers: _markers,
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
