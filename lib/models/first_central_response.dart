import 'package:flutter/foundation.dart';

class FirstCentralResponse {
  final String? status;
  final String? message;
  final dynamic data;

  FirstCentralResponse({this.status, this.message, this.data});

  factory FirstCentralResponse.fromJson(Map<String, dynamic> json) {
    return FirstCentralResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
