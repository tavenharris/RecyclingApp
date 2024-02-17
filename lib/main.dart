import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import the camera package
import 'Components/camera.dart'; // Adjust the path as needed
import 'Components/BottomSheet.dart'; // Adjust the path as needed
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras(); // Obtain the list of cameras
  runApp(
    DevicePreview(
      enabled: false,
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
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: CameraWidget(cameras: cameras)), // Pass the list of cameras to CameraWidget
            BottomWidget(),
          ],
        ),
      ),
    );
  }
}
