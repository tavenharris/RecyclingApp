import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CameraWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraWidget({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final String flaskEndpoint = 'http://127.0.0.1:5000/predict';

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

  Future<void> sendImageToServer(Uint8List imageBytes) async {
    var request = http.MultipartRequest('POST', Uri.parse(flaskEndpoint))
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'uploaded_image.jpg'));
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        final snackBar = SnackBar(content: Text('Server Response: $value'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      final snackBar = SnackBar(content: Text('Server error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
            return Center(child: Text('Error: ${snapshot.error}\nNo available cameras'));
          } else if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
            return SizedBox.expand(child: CameraPreview(_controller));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final XFile photo = await _controller.takePicture();
            Uint8List imageBytes = await photo.readAsBytes();
            sendImageToServer(imageBytes);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
