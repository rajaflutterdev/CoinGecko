import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  /// Post Method--create
  Future<http.Response> postData(
    String baseUrl,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse(baseUrl);
    print("update method is calling and baseUrl value is : $baseUrl");
    print("update method is calling and baseUrl value is : $data");
    final response = http.post(url, body: jsonEncode(data));
    return response;
  }

  /// get Method --read

  Future<http.Response> getData(String baseUrl) async {
    final url = Uri.parse(baseUrl);
    final response = http.get(url);
    return response;
  }

  /// update Method---update
  Future<http.Response> updateData(
    String baseUrl,
    Map<String, dynamic> data,
  ) async {
    print("update the value is--------$baseUrl--------- $data");
    final url = Uri.parse(baseUrl);
    final response = http.put(url, body: jsonEncode(data));
    return response;
  }

  /// delete Method--delete
  Future<http.Response> deleteData(String baseUrl) async {
    final url = Uri.parse(baseUrl);
    final response = http.delete(url);
    return response;
  }
}
