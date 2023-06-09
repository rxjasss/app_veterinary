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
  List<User> users = [];
  List<User> veterinarys = [];
  final storage = const FlutterSecureStorage();


  getUser() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    final url = Uri.http(_baseUrl, '/all/$id');
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
    await storage.write(key: 'id', value: decodedResp['id'].toString());
    isLoading = false;
    notifyListeners();

    String idUser = decodedResp['id'].toString();
    String usernameUser = decodedResp['username'].toString();
    String passwordUser = decodedResp['password'].toString();
    String nameUser = decodedResp['name'].toString();
    String surnameUser = decodedResp['surname'].toString();
    String enabledUser = decodedResp['surname'].toString();
    String roleUser = decodedResp['surname'].toString();
    String tokenUser = decodedResp['surname'].toString();

    User us = User(
        id: int.parse(idUser),
        username: usernameUser,
        password: passwordUser,
        name: nameUser,
        surname: surnameUser,
        enabled: bool.hasEnvironment(enabledUser),
        role: roleUser,
        token: tokenUser);

    return us;
  }

  Future<List> getListUsers() async {
    users.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/all/users');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<User> userList = decodedResp
        .map((u) => User(
              id: u['id'],
              name: u['name'],
              surname: u['surname'],
              username: u['username'],
              password: u['password'],
            ))
        .toList();
    users = userList;

    isLoading = false;
    notifyListeners();

    return userList;
  }

  Future<List> getListVeterinarys() async {
    veterinarys.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/all/veterinarys');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<User> veterinarysList = decodedResp
        .map((u) => User(
              id: u['id'],
              name: u['name'],
              surname: u['surname'],
              username: u['username'],
              password: u['password'],
            ))
        .toList();
    veterinarys = veterinarysList;

    isLoading = false;
    notifyListeners();

    return veterinarysList;
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




