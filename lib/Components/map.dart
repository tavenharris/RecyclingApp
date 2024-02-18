import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;




class TrashMap extends StatefulWidget {
  @override
  _TrashMapState createState() => _TrashMapState();
}




class _TrashMapState extends State<TrashMap> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? customIcon;
  LocationData? _currentLocation;
  bool _isLoading = true;
  String _error = '';
  Location location = Location();




  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcon();
    _determinePosition();
  }




  void _loadCustomMarkerIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/trash_bin_icon.png',
    );
    // Load the trash bins after the icon has been loaded.
    _loadTrashBins();
  }




  Future<void> _determinePosition() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;




    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled.';
          _isLoading = false;
        });
        return;
      }
    }




    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          _error = 'Location permissions are denied';
          _isLoading = false;
        });
        return;
      }
    }




    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _isLoading = false;
      });
      _updateCameraPosition(currentLocation);
      _addCurrentLocationMarker(currentLocation);
    });
  }




  void _updateCameraPosition(LocationData locationData) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 15.0, // Adjust zoom level as needed
        ),
      ),
    );
  }




  void _addCurrentLocationMarker(LocationData locationData) {
    final currentLocationMarker = Marker(
      markerId: MarkerId("current_location"),
      position: LatLng(locationData.latitude!, locationData.longitude!),
      infoWindow: InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );












    setState(() {
      _markers.add(currentLocationMarker);
    });
  }




  Future<void> _loadTrashBins() async {
    try {
      String jsonData = await rootBundle.loadString('assets/poi_data.json');
      Map<String, dynamic> jsonMap = json.decode(jsonData);
      List<dynamic> dataArray = jsonMap['data'];
      List<TrashBin> trashBins = dataArray.map((dataEntry) {
        final entryDetails = dataEntry.last as List; // Assuming the last element contains the details
        final name = dataEntry[8] as String; // Replace with the correct index for the name
        final latitude = double.tryParse(entryDetails[1]) ?? 0.0; // Replace with the correct index for latitude
        final longitude = double.tryParse(entryDetails[2]) ?? 0.0; // Replace with the correct index for longitude
        return TrashBin(name: name, latitude: latitude, longitude: longitude);
      }).toList();




      setState(() {
        _isLoading = false;
        _markers.clear();
        trashBins.forEach((bin) {
          _markers.add(Marker(
            markerId: MarkerId(bin.name),
            position: LatLng(bin.latitude, bin.longitude),
            infoWindow: InfoWindow(title: bin.name),
            icon: customIcon ?? BitmapDescriptor.defaultMarker,
          ));
        });
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load trash bins: $e';
        _isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash Map'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text("Error: $_error"))
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation != null
                        ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
                        : LatLng(37.77483, -122.41942), // Default fallback location
                    zoom: 15.0,
                  ),
                  markers: _markers,
                ),
    );
  }




  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}




class TrashBin {
  final String name;
  final double latitude;
  final double longitude;




  TrashBin({required this.name, required this.latitude, required this.longitude});
}















