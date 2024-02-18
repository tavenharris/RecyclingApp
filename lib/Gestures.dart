import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Components/BottomSheet.dart';
import 'Components/camera.dart';
import 'Components/map.dart'; // Import map.dart

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
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dx > 7) // if swipe right
        {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TrashMap(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(-1.0, 0.0);
                var end = Offset.zero;
                var tween = Tween(begin: begin, end: end);
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: CameraWidget(
        cameras: cameras,
      ),
    );
  }
}
