import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_endpoints.dart';

class RemoteDataSource {
  static Future<bool> login(FormData data) async {
    try {
      Dio dio = Dio();
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login;
      Response response = await dio.post(url,
          data: data,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        if (response.data['status'] == 'ok') {
          // throw jsonDecode(response.body)['message'];
          // var token = json['data']['Token'];
          // final SharedPreferences prefs = await _prefs;
          // await prefs.setString('token', token);
          // emailController.clear();
          // passwordController.clear();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // SAVE TRANSACTION
  static Future<bool> saveTransaction(List<dynamic> data) async {
    // String jsonData = jsonEncode(data);
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.saveTransaction;
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // GET TRANSACTION
  static Future<List<TransactionModel>?> getTransactions() async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getTransactions;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        // print(jsonData);
        return jsonData.map((e) => TransactionModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // LIST PRODUCT
  static Future<List<ProductModel>?> getProduct() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.product;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        // print(jsonData);
        return jsonData.map((e) => ProductModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
