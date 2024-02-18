import 'package:flutter/material.dart';
import 'package:untitled1/global_variables.dart';
import '../Pages/Details.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Scan Some Trash'; // Default title

    // Check prediction value and update title accordingly
    if (GlobalVariables.serverResponse?.prediction == 'R') {
      title = 'Recyclable';
    } else if (GlobalVariables.serverResponse?.prediction == 'O') {
      title = 'Compostable';
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300.0, // Increased height to 300.0
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 35, 212, 68),
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
                  title, // Use the dynamically determined title
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Prediction: ${GlobalVariables.serverResponse?.prediction}\nAccuracy: ${GlobalVariables.serverResponse?.accuracy}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()), // Expanded to fill remaining space
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
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
                    // Handle the error gracefully, such as showing a snackbar or dialog
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('More information'),
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
