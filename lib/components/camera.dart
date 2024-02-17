import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// A widget that displays the camera's preview.
class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Take a Photo')),
      body: CameraPreview(controller!),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            await controller!.initialize();
            final image = await controller!.takePicture();
            await _showSnackBarWithPhoto(context, image);
          } catch (e) {
            print(e); // Handle the error
          }
        },
      ),
    );
  }

  Future<void> _showSnackBarWithPhoto(BuildContext context, XFile photo) async {
    final snackBar = SnackBar(content: Text('Photo taken!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Optionally, save the photo to the file system
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = join(directory.path, '${DateTime.now()}.png');
    await photo.saveTo(imagePath);
  }
}
