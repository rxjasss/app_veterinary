// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_veterinary/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:app_veterinary/Models/models.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.10:8080';
  bool isLoading = true;
  
  String usuario = "";
  final storage = const FlutterSecureStorage();


  getUser() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    final url = Uri.http(_baseUrl, '/public/api/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    await storage.write(
        key: 'id', value: decodedResp['data']['id'].toString());
    isLoading = false;
    notifyListeners();
    return decodedResp['data']['id'].toString();
  }

  Future<String?> update(
    String name,
    String surname,
    String username,
    String password,
  ) async {
    String id = await AuthService().readId();
    final Map<String, dynamic> authData = {
      'id': id,
      'name': name,
      'surname': surname,
      'username': username,
      'password': password,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/all/update');

    final resp = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: encodedFormData);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (resp.statusCode == 200) {
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (resp.statusCode.toString());
    } else {
      return (resp.statusCode.toString());
    }
  }
}




