import 'dart:io';
import 'package:hackaton_fridge/models/response_fromJson.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectRepo {
  final mainUrl = "https://tirmizako-fridge-hackaton.herokuapp.com/";
  Dio _dio;
  ProjectRepo() {
    _dio = Dio(BaseOptions(baseUrl: mainUrl));
  }

  Future<bool> signUp(String username, String password) async {
    final endPoint = "auth/sign-up";
    final data = FormData.fromMap({"username": username, "password": password});
    try {
      Response response = await _dio.post(endPoint, data: data);
      if (response.statusCode == HttpStatus.created) {
        return true;
      }
      return false;
    } catch (error) {
      print("$error");
      return false;
    }
  }

  Future<String> signIn(String username, String password) async {
    final endPoint = "auth/sign-in";
    final data = FormData.fromMap({"username": username, "password": password});
    try {
      Response response = await _dio.post(endPoint, data: data);
      if (response.statusCode == HttpStatus.ok) {
        await localSignUp(response.data['Token']);
        if (_dio.interceptors.isNotEmpty) {
          _dio.interceptors.removeLast();
        }
        _dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options) async {
            var customHeader = {"Authorization": response.data['Token']};
            options.headers.addAll(customHeader);
            return options;
          },
        ));

        return response.data['Token'];
      }
      return "Error";
    } catch (error) {
      print("$error");
      return "Error";
    }
  }

  Future<bool> localSignIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("Token");
    if (token != null) {
      if (_dio.interceptors.isNotEmpty) {
        _dio.interceptors.removeLast();
      }
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options) async {
          var customHeader = {"Authorization": token};
          options.headers.addAll(customHeader);
          return options;
        },
      ));
      return true;
    }
    return false;
  }

  Future<void> localSignUp(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("Token", token);
  }

  Future<bool> localSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool res = await preferences.remove("Token");
    return res;
  }

  Future<ResponseFromJson> getProducts() async {
    final String link = "expiration/get_all";
    try {
      Response response = await _dio.get(link);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return ResponseFromJson.withError("Error: getting data");
    }
  }

  Future<ResponseFromJson> getExpiredProducts() async {
    final String link = "expiration/get_expired_products";
    try {
      Response response = await _dio.get(link);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return ResponseFromJson.withError("Error: getting data");
    }
  }

  Future<ResponseFromJson> getFreshProducts() async {
    final String link = "expiration/get_fresh";
    try {
      Response response = await _dio.get(link);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return ResponseFromJson.withError("Error: getting data");
    }
  }

  Future<ResponseFromJson> addProduct(
      {String name,
      String expireDate,
      String category,
      String unit,
      double quantity,
      File file}) async {
    final String endPoint = "products/add";
    try {
      final data = FormData.fromMap({
        "name": name,
        "expire_date": expireDate,
        "file": await MultipartFile.fromFile(file.path),
        "category": category,
        "quantity": quantity,
        "unit": unit,
        "barcode":"1"
      });
      Response response = await _dio.post(endPoint, data: data);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (error) {
      print("$error");
      return ResponseFromJson.withError("Error adding product");
    }
  }

  Future<ResponseFromJson> addProductQr(
      {String name,
      String expireDate,
      String category,
      String unit,
      double quantity,
      File file,
      String qr}) async {
    final String endPoint = "products/add";
    try {
      final data = FormData.fromMap({
        "name": name,
        "expire_date": expireDate,
        "file": await MultipartFile.fromFile(file.path),
        "category": category,
        "quantity": quantity,
        "unit": unit,
        "barcode": qr
      });
      Response response = await _dio.post(endPoint, data: data);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (error) {
      print("$error");
      return ResponseFromJson.withError("Error adding product");
    }
  }

  Future<bool> removeByBarcode(String barcode) async {
    final String endPoint = "products/remove_barcode";
    final data = FormData.fromMap({"barcode": barcode});
    try {
      Response response = await _dio.delete(endPoint, data: data);
      print(response.statusCode);
      return true;
    } catch (error) {
      print("$error");
      return false;
    }
  }

  Future<void> updateDate() async {
    final String endPoint = "expiration/check";
    var date = DateTime.now();
    final data =
        FormData.fromMap({"today": "${date.day}.${date.month}.${date.year}"});
    try {
      Response response = await _dio.post(endPoint, data: data);
      print(response.statusCode);
    } catch (error) {
      print("$error");
    }
  }

  Future<bool> addToCart(int fruitId) async {
    final String endPoint = "cart/add";
    final data = FormData.fromMap({"fruit_id": fruitId});
    try {
      Response response = await _dio.post(endPoint, data: data);
      print(response.statusCode);
      return true;
    } catch (error) {
      print("$error");
      return false;
    }
  }

  Future<ResponseFromJson> getCartProducts() async {
    final String endPoint = "cart/get_products";
    try {
      Response response = await _dio.get(endPoint);
      print(response.data);
      return ResponseFromJson.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return ResponseFromJson.withError("Error: getting data");
    }
  }

  Future<bool> removeProduct(int fruitId) async {
    final String endPoint = "products/delete";
    final data = FormData.fromMap({"fruit_id": fruitId});
    try {
      Response response = await _dio.delete(endPoint, data: data);
      print(response.data);
      return true;
    } catch (error) {
      print("$error");
      return false;
    }
  }
}

final projectRepo = ProjectRepo();
