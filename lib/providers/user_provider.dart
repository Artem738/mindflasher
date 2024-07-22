import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher/system/validation_exception.dart';
import '../models/user.dart';
import '../env_config.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> register(String name, String username, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}api/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners();
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw ValidationException(errors);
      } else {
        throw Exception('Failed to register: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _token = responseData['access_token'];

        // Получение данных пользователя
        final userResponse = await http.get(
          Uri.parse('${EnvConfig.mainApiUrl}api/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );

        if (userResponse.statusCode == 200) {
          print(userResponse.body);

          _user = User.fromJson(json.decode(userResponse.body));
        } else {
          throw Exception('Failed to fetch user data');
        }

        notifyListeners();
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw ValidationException(errors);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to login: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
