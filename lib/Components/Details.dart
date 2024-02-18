import 'package:flutter/material.dart';
import 'package:untitled1/global_variables.dart'; // Import GlobalVariables to access the storedImageBytes

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text(
          'Scan Information',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is the second page...'),
            if (GlobalVariables.storedImageBytes != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(GlobalVariables.storedImageBytes!),
              ),
          ],
        ),
      ),
    );
  }
}