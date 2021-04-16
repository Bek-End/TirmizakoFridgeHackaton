import 'dart:io';

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
}

final projectRepo = ProjectRepo();
