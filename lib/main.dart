import 'package:camera/camera.dart'; // Import the camera package
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'Components/map.dart'; // Make sure this path is correct for your map widget
import 'Gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras =
      await availableCameras(); // Obtain the list of cameras
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(cameras: cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder, // Use this only if you're using DevicePreview in your app
      home: DevicePreview(
        enabled: false, // Use this only if you're using DevicePreview in your app
        builder: (context) => Scaffold(
          body: Column(
            children: [
              Expanded(
                // This widget is for your gestures
                child: Gestures(cameras: cameras),
              ),   
            ],
          ),
        ),
      ),
    );
  }
}
