// Model untuk request change number
class ChangeNumberRequest {
  final String nomorBaru;

  ChangeNumberRequest({required this.nomorBaru});

  Map<String, dynamic> toJson() {
    return {
      'nomorBaru': nomorBaru,
    };
  }
}

// Model untuk response
class ChangeNumberResponse {
  final String message;

  ChangeNumberResponse({required this.message});

  factory ChangeNumberResponse.fromJson(Map<String, dynamic> json) {
    return ChangeNumberResponse(
      message: json['message'] ?? '',
    );
  }
}