
class TrashBin {
  final String name;
  final double latitude;
  final double longitude;

  TrashBin({required this.name, required this.latitude, required this.longitude});

  factory TrashBin.fromJson(Map<String, dynamic> json) {
    // Assuming 'name', 'latitude', and 'longitude' keys exist in the JSON
    // Using 'tryParse' for latitude and longitude to handle possible non-double values
    final String name = json['name'] ?? 'Unknown'; // Default to 'Unknown' if name is null
    final double latitude = double.tryParse(json['latitude'].toString()) ?? 0.0; // Default to 0.0 if latitude is null or not a valid double
    final double longitude = double.tryParse(json['longitude'].toString()) ?? 0.0; // Default to 0.0 if longitude is null or not a valid double

    return TrashBin(
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }
}