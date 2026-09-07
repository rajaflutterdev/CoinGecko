import 'dart:convert';

import 'package:stu/Core/Network/ApiService.dart';

import '../../../Core/Network/ExceptionHandling.dart';
import 'model/userDataModel.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  /// user GetMethod

  Future<List<UserDataModel>> getUserData(String baseUrl) async {
    try {
      final responseData = await apiService.getData(baseUrl);
      List<dynamic> data = jsonDecode(responseData.body);
      ErrorHandling.httpException(responseData.statusCode);
      return data.map((json) => UserDataModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// delete method

  Future<http.Response> deleteUserData(String baseUrl) async {
    try {
      final responseData = await apiService.deleteData(baseUrl);
      ErrorHandling.httpException(responseData.statusCode);
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  ///update Method
  Future<http.Response> updateUserData(
    String baseUrl,
    UserDataModel data,
  ) async {
    try {
      final responseData = await apiService.updateData(baseUrl, data.toJson());
      ErrorHandling.httpException(responseData.statusCode);
      return responseData;
    } catch (e) {
      print(e.runtimeType);
      print(e.toString());
      rethrow;
    }
  }

  /// post methdd
  Future<http.Response> postUserData(
      String baseUrl,
      UserDataModel data,
      ) async {
    try {
      final responseData = await apiService.postData(baseUrl, data.toJson());
      ErrorHandling.httpException(responseData.statusCode);
      return responseData;
    } catch (e) {
      print(e.runtimeType);
      print(e.toString());
      rethrow;
    }
  }
}
