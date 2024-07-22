import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindflasher/system/validation_exception.dart';
import '../models/user.dart';
import '../env_config.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = true;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      await _loadUser();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<void> _loadUser() async {
    final userResponse = await http.get(
      Uri.parse('${EnvConfig.mainApiUrl}api/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (userResponse.statusCode == 200) {
      _user = User.fromJson(json.decode(userResponse.body));
    } else {
      _token = null;
      _user = null;
      await _removeToken();
    }

    notifyListeners();
  }

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
        await _saveToken(_token!);

        await _loadUser();
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

  void logout() async {
    _token = null;
    _user = null;
    await _removeToken();
    notifyListeners();
  }
}
