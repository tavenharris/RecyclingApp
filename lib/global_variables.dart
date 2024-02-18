import 'dart:typed_data';
import 'modules/cnn_response.dart';

class GlobalVariables {
  static ServerResponse? serverResponse; // Update the type to ServerResponse
  static Uint8List? storedImageBytes; // Add this line to store image bytes
  static Uint8List? imageBytes; 
}