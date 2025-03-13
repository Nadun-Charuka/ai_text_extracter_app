import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiServiceMethodeType {
  get,
  post,
}

const baseUrl = "https://api.stripe.com/v1";

final Map<String, String> requestHeaders = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
};

Future<Map<String, dynamic>?> stripeApiService({
  required ApiServiceMethodeType requestMethod,
  Map<String, dynamic>? requestBody,
  required String endPoint,
}) async {
  final requestUrl = "$baseUrl/$endPoint";
  try {
    final requestResponse = requestMethod == ApiServiceMethodeType.get
        ? await http.get(
            Uri.parse(requestUrl),
            headers: requestHeaders,
          )
        : await http.post(
            Uri.parse(requestUrl),
            headers: requestHeaders,
            body: requestBody,
          );
    if (requestResponse.statusCode == 200) {
      return json.decode(requestResponse.body);
    } else {
      debugPrint(requestResponse.body);
      throw Exception("Failed to fetch data: ${requestResponse.body}");
    }
  } catch (e) {
    debugPrint("$e");
    return null;
  }
}
