class ServerResponse {
  final String prediction;
  final double accuracy;

  ServerResponse({
    required this.prediction,
    required this.accuracy,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      prediction: json['prediction'],
      accuracy: json['confidence'],
    );
  }
}
