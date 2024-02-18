import 'package:flutter/material.dart';
import 'package:untitled1/global_variables.dart';
import 'Details.dart';

class BottomWidget extends StatelessWidget {
  BottomWidget({Key? key}) : super(key: key);

  final Color defaultBackgroundColor = Colors.white;
  final Color greenBackgroundColor = const Color.fromARGB(255, 32, 233, 39);
  final Color blueBackgroundColor = Colors.blue;

  Color getBackgroundColor(String? prediction) {
    if (prediction == 'R') {
      return blueBackgroundColor;
    } else if (prediction == 'O') {
      return greenBackgroundColor;
    }
    return defaultBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Scan Some Trash';

    if (GlobalVariables.serverResponse?.prediction == 'R') {
      title = 'Recyclable';
    } else if (GlobalVariables.serverResponse?.prediction == 'O') {
      title = 'Compostable';
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      decoration: BoxDecoration(
        color: getBackgroundColor(GlobalVariables.serverResponse?.prediction),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Accuracy: ${GlobalVariables.serverResponse?.accuracy != null ? (GlobalVariables.serverResponse!.accuracy * 100).toStringAsFixed(2) + '%' : 'N/A'}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  fixedSize: Size(210, 50), // Adjust the size here
                ),
                onPressed: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    );
                  } catch (e) {
                    print('Error navigating to SecondPage: $e');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('More information', style: TextStyle(fontSize: 17)), // Adjust the font size here
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
