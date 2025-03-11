import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionModel {
  final String userId;
  final String conversionData;
  final DateTime conversionDate;

  ConversionModel({
    required this.userId,
    required this.conversionData,
    required this.conversionDate,
  });

  //json >> conversion model
  //this is a factry name constructer
  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      userId: json["userId"],
      conversionData: json["conversionData"],
      conversionDate: (json["conversionDate"] as Timestamp).toDate(),
    );
  }

  //conversionmodel >> json{}
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "conversionData": conversionData,
      "conversionDate": conversionDate,
    };
  }
}
