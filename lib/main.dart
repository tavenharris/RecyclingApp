import 'package:camera/camera.dart'; // Import the camera package
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

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
      builder: DevicePreview.appBuilder,
      home: DevicePreview(
        enabled: false,
        builder: (context) => Scaffold(
          body: Column(
            children: [
              Expanded(child: Gestures(cameras: cameras, context: context))
            ],
          ),
        ),
      ),
    );
  }
}
