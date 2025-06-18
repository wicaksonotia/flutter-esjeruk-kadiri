import 'dart:async';
import 'package:dio/dio.dart';
import 'package:esjerukkadiri/models/product_category_model.dart';
import 'dart:convert';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSource {
  static Future<bool> login(FormData data) async {
    try {
      Dio dio = Dio();
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login;
      Response response = await dio.post(
        url,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == 'ok') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('statusLogin', true);
          await prefs.setInt('id_kasir', response.data['id_kasir']);
          await prefs.setString('nama_kasir', response.data['nama_kasir']);
          await prefs.setInt('id_kios', response.data['id_kios']);
          await prefs.setString('kios', response.data['kios']);
          await prefs.setInt('id_cabang', response.data['id_cabang']);
          await prefs.setString('cabang', response.data['cabang']);
          await prefs.setString(
            'alamat_cabang',
            response.data['alamat_cabang'],
          );
          await prefs.setString('phone_cabang', response.data['phone_cabang']);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // PRODUCT CATEGORIES
  static Future<List<ProductCategoryModel>?> getProductCategories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = jsonEncode({'id_kios': prefs.getInt('id_kios') ?? 0});
      Dio dio = Dio();
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories;
      Response response = await dio.post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => ProductCategoryModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // PRODUCT
  static Future<List<ProductModel>?> getProduct(
    Map<String, dynamic> rawFormat,
  ) async {
    try {
      Dio dio = Dio();
      var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.product;
      Response response = await dio.post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((e) => ProductModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // SAVE TRANSACTION
  static Future<bool> saveTransaction(
    Map<String, dynamic> dataTransaction,
    List<dynamic> dataDetail,
  ) async {
    try {
      var rawFormat = jsonEncode({
        'transaction': dataTransaction,
        'details': dataDetail,
      });
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.saveTransaction;
      Response response = await dio.post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == 'ok') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('transaction_id', response.data['transaction_id']);
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // DELETE TRANSACTION
  static Future<bool> deleteTransaction(Map<String, dynamic> rawFormat) async {
    try {
      Dio dio = Dio();
      var url =
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deleteTransaction;
      Response response = await dio.delete(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // GET TRANSACTION DETAIL BY NUMERATOR AND KIOS
  static Future<TransactionModel?> getDetailTransaction(
    Map<String, dynamic> data,
  ) async {
    try {
      var rawFormat = jsonEncode(data);
      var url =
          ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getDetailTransaction;
      final response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final TransactionModel res = TransactionModel.fromJson(response.data);
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<TransactionHistoryModel?> transactionHistoryByDateRange(
    Map<String, dynamic> data,
  ) async {
    try {
      var rawFormat = Map<String, dynamic>.from(data);
      rawFormat['startDate'] = data['startDate'].toString();
      rawFormat['endDate'] = data['endDate'].toString();
      var url =
          ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.transactionHistoryByDateRange;
      Response response = await Dio().post(
        url,
        data: jsonEncode(rawFormat),
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final TransactionHistoryModel res = TransactionHistoryModel.fromJson(
          response.data,
        );
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<TransactionHistoryModel?> transactionHistoryByMonth(
    Map<String, dynamic> data,
  ) async {
    try {
      var rawFormat = jsonEncode(data);
      var url =
          ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.transactionHistoryByMonth;
      Response response = await Dio().post(
        url,
        data: rawFormat,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        final TransactionHistoryModel res = TransactionHistoryModel.fromJson(
          response.data,
        );
        return res;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
