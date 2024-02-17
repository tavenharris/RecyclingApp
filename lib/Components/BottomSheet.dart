import 'package:flutter/material.dart';



class BottomWidget extends StatelessWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      color: Colors.white,
      child: Center(
        child: Text('I\'m a bottom widget',
            style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    );
  }
}