import 'package:flutter/cupertino.dart';
import 'package:project4_flutter/shared/api/api_service.dart';
import 'package:project4_flutter/shared/models/custom_result.dart';
import 'package:project4_flutter/shared/models/property.dart';

class PropertyDetailApi {
  final ApiService apiService = ApiService();
  Future<Property?> getProperty(int id) async {

      //response is map<String, dynamic>
      var response = await apiService.get("listingCM", params: {"id": id});

      //convert to json
      var customResult = CustomResult.fromJson(response);

      if (customResult.status == 200) {
        //get data from customResult and convert to Property object
        var property = Property.fromJson(customResult.data);
        return property;
      }
      return null;

  }
}
