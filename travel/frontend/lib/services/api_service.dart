import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() => _instance;
  ApiService._internal();

  // Global navigation key to access Navigator without context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  // Save tokens to shared preferences
  Future<void> saveTokens({String? accessToken, String? refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (accessToken != null) {
      await prefs.setString('access_token', accessToken);
    }
    
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken);
    }
  }

  // Clear tokens (for logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await saveTokens(
          accessToken: responseData['access'],
          refreshToken: responseData.containsKey('refresh') ? responseData['refresh'] : null,
        );
        return true;
      } else {
        print('Токен шинэчлэх алдаа: ${response.statusCode}');
        print('Алдааны мэдээлэл: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Токен шинэчлэх үед алдаа гарлаа: $e');
      return false;
    }
  }

  // Making authenticated GET request with token refresh
  Future<http.Response> get(String endpoint) async {
    return _request(
      () => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ),
    );
  }

  // Making authenticated POST request with token refresh
  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    return _request(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  // Making authenticated PUT request with token refresh
  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    return _request(
      () => http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  // Making authenticated DELETE request with token refresh
  Future<http.Response> delete(String endpoint) async {
    return _request(
      () => http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ),
    );
  }

  // Headers with current access token
  late Map<String, String> _headers;
  
  // Generic request method with token refresh logic
  Future<http.Response> _request(Future<http.Response> Function() requestMethod) async {
    // Get current access token
    final accessToken = await getAccessToken();
    _headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    // Make the request
    var response = await requestMethod();
    
    // If unauthorized and we have a refresh token, try to refresh and retry
    if (response.statusCode == 401) {
      final refreshSuccess = await refreshToken();
      
      if (refreshSuccess) {
        // Update header with new token
        final newAccessToken = await getAccessToken();
        _headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $newAccessToken',
        };
        
        // Retry the request with new token
        response = await requestMethod();
      } else {
        // If refresh failed, navigate to login
        navigateToLogin();
      }
    }
    
    return response;
  }

  // Navigate to login page
  void navigateToLogin() {
    // Use the global navigator key to navigate without context
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}