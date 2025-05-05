import 'dart:async';
import 'package:dio/dio.dart';
import 'package:esjerukkadiri/models/product_category_model.dart';
import 'dart:convert';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/models/transaction_detail_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('statusLogin', true);
          await prefs.setString('username', response.data['username']);
          await prefs.setString('alamat', response.data['alamat']);
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
  static Future<bool> saveDetailTransaction(List<dynamic> data) async {
    // String jsonData = jsonEncode(data);
    try {
      Dio dio = Dio();
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.saveDetailTransaction;
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'numerator', response.data['numerator'].toString());
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> saveTransaction(String kios, int discount) async {
    try {
      var rawFormat = jsonEncode({'kios': kios, 'discount': discount});
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.saveTransaction;
      Response response = await dio.post(url,
          data: rawFormat,
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

  // DELETE TRANSACTION
  static Future<bool> deleteTransaction(int numerator, String kios) async {
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deleteTransaction;
      Response response =
          await dio.delete('$url?numerator=$numerator&kios=$kios');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // GET TRANSACTION
  static Future<List<TransactionModel>?> getHistoryTransactions(
      DateTime startdate,
      DateTime enddate,
      DateTime singledate,
      bool checksingledate) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = (jsonEncode({
        'startdate': startdate.toString(),
        'enddate': enddate.toString(),
        'singledate': singledate.toString(),
        'checksingledate': checksingledate,
        'username': prefs.getString('username'),
      }));
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getHistoryTransactions;
      // final response = await Dio().get(
      //     '$url?startdate=$startdate&enddate=$enddate&singledate=$singledate&checksingledate=$checksingledate');
      Response response = await Dio().post(url,
          data: rawFormat,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
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

  // GET TRANSACTION DETAIL BY NUMERATOR AND KIOS
  static Future<TransactionModel?> getRowTransactionDetails(
      int numerator, String kios) async {
    try {
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getRowTransactions;
      final response = await Dio().get('$url?numerator=$numerator&kios=$kios');
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return TransactionModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // GET LIST TRANSACTION DETAILS BY NUMERATOR AND KIOS
  static Future<List<TransactionDetailModel>?> getListTransactionDetails(
      int numerator, String kios) async {
    try {
      var url = ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getTransactionDetails;
      final response = await Dio().get('$url?numerator=$numerator&kios=$kios');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        // print(jsonData);
        return jsonData.map((e) => TransactionDetailModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // PRODUCT CATEGORIES
  static Future<List<ProductCategoryModel>?> getProductCategories() async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories;
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => ProductCategoryModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // LIST PRODUCT
  static Future<List<ProductModel>?> getProduct(int id) async {
    try {
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.product;
      final response = await Dio().get('$url?productcategory=$id');
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
