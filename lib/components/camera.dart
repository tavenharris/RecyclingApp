import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraWidget({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    _controller = CameraController(widget.cameras.first, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
            // Ensure the CameraPreview is fullscreen by using SizedBox.expand
            return SizedBox.expand(
              child: CameraPreview(_controller),
            );
          } else {
            // Show loading spinner until the camera is initialized
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            // Ensure that the camera is initialized before taking a picture
            await _initializeControllerFuture;
            final XFile photo = await _controller.takePicture();
            // Update imagePath with the path where the photo was stored
            setState(() {
              imagePath = photo.path;
            });
            // Show a SnackBar with a clickable action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Photo taken!'),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {
                    // Handle action press here (e.g., navigate to the photo)
                    // For simplicity, we're just printing the path
                    print(imagePath);
                  },
                ),
              ),
            );
          } catch (e) {
            print("Error taking picture: $e");
          }
        },
      ),
    );
  }
}
