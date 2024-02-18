import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'global_variables.dart';
import 'Components/BottomSheet.dart';
import 'Components/camera.dart';

class Gestures extends StatelessWidget {
  final List<CameraDescription> cameras;

  Gestures({Key? key, required this.cameras}) : super(key: key);

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
        cameras: cameras,
      ),
    );
  }
}
