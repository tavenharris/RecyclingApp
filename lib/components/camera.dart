import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:untitled1/Components/BottomSheet.dart';

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
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(widget.cameras.first, ResolutionPreset.max);
      _initializeControllerFuture = _controller.initialize();
    } else {
      _initializeControllerFuture = Future.error('No available cameras');
    }
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
          if (snapshot.hasError) {
            // If there's an error, display a relevant message
            return Center(child: Text('Error: ${snapshot.error}\nNo available cameras'));
          } else if (snapshot.connectionState == ConnectionState.done &&
              _controller.value.isInitialized) {
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
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return BottomWidget();
              }
          );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
