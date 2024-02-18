import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Components/BottomSheet.dart';
import 'Components/camera.dart';

class Gestures extends StatelessWidget {
  final List<CameraDescription> cameras;
  final BuildContext context;

  Gestures({Key? key, required this.cameras, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -7) // if swipe up
        {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return BottomWidget();
            },
          );
        }
      },
      child: CameraWidget(
          cameras: cameras), // Pass the list of cameras to CameraWidget
    );
  }
}
