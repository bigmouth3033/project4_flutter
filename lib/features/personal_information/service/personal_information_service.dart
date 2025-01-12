import 'dart:convert';

import 'package:project4_flutter/features/login_and_security/models/change_password_request.dart';
import 'package:project4_flutter/features/login_and_security/models/otp_confirm_request.dart';
import 'package:project4_flutter/features/personal_information/models/legal_name_request.dart';
import 'package:http/http.dart' as http;
import 'package:project4_flutter/features/personal_information/models/phone_number_request.dart';
import 'package:project4_flutter/features/personal_information/models/preferred_name_request.dart';
import 'package:project4_flutter/shared/utils/token_storage.dart';

class PersonalInformationService {
  final String baseUrl = "192.168.1.6:8080";
  var tokenStorage = TokenStorage();

  Future putLegalName(LegalNameRequest request) async {
    var token = await tokenStorage.getToken();

    var uri = Uri.http(baseUrl, "/userCM/legalName");
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $token",
        },
        body: request.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to update legal name');
    }
  }

  Future putPreferredName(PreferredNameRequest request) async {
    var token = await tokenStorage.getToken();
    var uri = Uri.http(baseUrl, "/userCM/preferredName");
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $token",
        },
        body: request.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update preferred name');
    }
  }

  Future putPhoneNumber(PhoneNumberRequest request) async {
    var token = await tokenStorage.getToken();
    var uri = Uri.http(baseUrl, "/userCM/phoneNumber");
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $token",
        },
        body: request.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update Phone number');
    }
  }

  Future putChangePassword(ChangePasswordRequest request) async {
    var token = await tokenStorage.getToken();
    var uri = Uri.http(baseUrl, "/userCM/changePassword");
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $token",
        },
        body: request.toJson());
    var customResult = jsonDecode(response.body);

    if (response.statusCode == 200 && customResult['status'] == 404) {
      print(customResult['message']);
      throw Exception(customResult['message']);
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to update Password');
    }
  }

  Future putCheckOtp(OtpConfirmRequest request) async {
    var token = await tokenStorage.getToken();
    var uri = Uri.http(baseUrl, "/userCM/checkOTP");
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer $token",
        },
        body: request.toJson());

    var customResult = jsonDecode(response.body);
    print(customResult);

    if (response.statusCode == 200 && customResult['status'] == 404) {
      print(customResult['message']);
      throw Exception(customResult['message']);
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to update Password');
    }
  }
}
