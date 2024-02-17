import 'package:flutter/material.dart';
import 'components/camera.dart'; // Make sure the path matches where your camera.dart file is located
import 'package:untitled1/Components/BottomSheet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: CameraWidget()),
            BottomWidget(),
          ],
        )
      ),
    );
  }
}
