import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "192.168.1.4:8080";

  ApiService();

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic> params = const {},
      Map<String, String>? headers}) async {
    Map<String, dynamic> stringParams =
        params.map((key, value) => MapEntry(key, value?.toString()));

    var uri = Uri.http(baseUrl, endpoint, stringParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    var uri = Uri.http(baseUrl, endpoint);
    final request = http.MultipartRequest('POST', uri);

    if (headers != null) {
      request.headers.addAll(headers);
    }

    body.forEach((key, value) {
      if (value != null) {
        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            request.fields['$key[$i]'] = value[i].toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      }
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception(
          "Failed to load data, status code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    var uri = Uri.http(baseUrl, endpoint);
    final request = http.MultipartRequest('POST', uri);

    if (headers != null) {
      request.headers.addAll(headers);
    }

    body.forEach((key, value) => request.fields[key] = value);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception(
          "Failed to load data, status code: ${response.statusCode}");
    }
  }
}
