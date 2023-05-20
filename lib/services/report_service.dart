import 'dart:convert';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'services.dart';

class ReportService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.9:8080';
  bool isLoading = true;
  List<Report> reports = [];
  String report = "";
  Report p = Report();
  final storage = const FlutterSecureStorage();

  //GET USER REPORTS 
  getReportsUser(String id) async {
    reports.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/reports/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Report> reportList = decodedResp
        .map((e) => Report(
              id: e['id'],
              idUser: e['idUser'],
              idVeterinary: e['idVeterinary'],
              description: e['description'],
            ))
        .toList();

    reports = reportList;
    isLoading = false;
    notifyListeners();

    return reportList;
  }


 //GET VETERINARY REPORTS 
  getReportsVeterinary(String id) async {
    reports.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/veterinary/reports/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Report> reportList = decodedResp
        .map((e) => Report(
              id: e['id'],
              idUser: e['idUser'],
              idVeterinary: e['idVeterinary'],
              description: e['description'],
            ))
        .toList();

    reports = reportList;
    isLoading = false;
    notifyListeners();

    return reportList;
  }
}