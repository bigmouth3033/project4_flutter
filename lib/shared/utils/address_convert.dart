import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:project4_flutter/shared/models/address.dart'; // for rootBundle

Future<AddressData> loadAddresses() async {
  // Load JSON from assets
  String jsonString = await rootBundle.loadString('assets/data/dchc.json');

  // Decode JSON and map to AddressData model
  final Map<String, dynamic> jsonResponse = json.decode(jsonString);
  print(jsonString);
  return AddressData.fromJson(jsonResponse);
}

Future<String> convertAddressCode(String addressCode) async {
  // Load the address data from the JSON file
  AddressData addressData = await loadAddresses();
  print(addressCode);
  // Split the addressCode into its components
  List<String> addressArr = addressCode.split("_");

  // Find the province (Level 1)
  Level1? province = addressData.data.firstWhere(
    (level1) => level1.level1_id == addressArr[0],
    orElse: () => Level1(level1_id: '', name: '', type: '', level2s: []),
  );
  print(province);

  // Find the district (Level 2) within the selected province
  Level2? district = province.level2s.firstWhere(
    (level2) => level2.level2_id == addressArr[1],
    orElse: () => Level2(level2_id: '', name: '', type: '', level3s: []),
  );
  print(district);
  // Find the ward (Level 3) within the selected district
  Level3? ward = district.level3s.firstWhere(
    (level3) => level3.level3_id == addressArr[2],
    orElse: () => Level3(level3_id: '', name: '', type: ''),
  );
  print(ward);
  // Return the formatted address
  return '${ward.name}, ${district.name}, ${province.name}';
}
