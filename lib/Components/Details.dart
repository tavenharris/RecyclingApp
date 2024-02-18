import 'dart:async';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late DateTime startTime;

  @override
  void initState() {
    startTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'More Information',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            _buildRichText('• On average, Americans throw away about ', '1,200 pounds', ' of organic garbage each year.'),
            _buildRichText('• We only recycle about ', '67.2 million tons', ' of a possible ', '267.8 million tons', ' – less than a quarter of total MSW.'),
            _buildRichText('• The EPA estimates that around ', '75% of all waste', ' is recyclable.'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: '• Each American produces about '),
                    TextSpan(text: '4.51 pounds of trash', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' in a single day.'),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
                final trashGenerated = elapsedSeconds * 4.4;
                return Column(
                  children: [
                    Text(
                      'Trash generated since you opened this page:',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${trashGenerated.toStringAsFixed(2)} tons',
                      style: TextStyle(fontSize: 46.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String normalText1, String boldText1, String normalText2, [String? boldText2, String? normalText3]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: normalText1),
            TextSpan(text: boldText1, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: normalText2),
            if (boldText2 != null && normalText3 != null) ...[
              TextSpan(text: boldText2, style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: normalText3),
            ],
          ],
        ),
      ),
    );
  }
}