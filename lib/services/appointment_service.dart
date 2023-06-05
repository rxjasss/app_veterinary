import 'dart:convert';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'services.dart';

class AppointmentService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.3:8080';
  bool isLoading = true;
  List<Appointment> appointments = [];
  List<Appointment> appointmentsPets = [];
  String appointment = "";
  Appointment a = Appointment();
  final storage = const FlutterSecureStorage();

  //GET VETERINARY APPOINTMENTS 
  getAppointmentsVeterinary(String idVeterinary) async {
    appointments.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/veterinary/appointments/$idVeterinary');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Appointment> appointmentList = decodedResp
        .map((e) => Appointment(
              id: e['id'],
              idPet: e['idPet'],
              idUser: e['idUser'],
              hour: e['hour'],
              date: e['date'],
              
            ))
        .toList();

    appointments = appointmentList;
    isLoading = false;
    notifyListeners();

    return appointmentList;
  }

//GET PET APPOINTMENTS 
  getAppointmentsPet(String idPet) async {
    appointmentsPets.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/user/appointments/$idPet');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Appointment> appointmentListPets = decodedResp
        .map((e) => Appointment(
              id: e['id'],
              idPet: e['idPet'],
              idUser: e['idUser'],
              hour: e['hour'],
              date: e['date'],
              
            ))
        .toList();
    appointmentsPets = appointmentListPets;
    isLoading = false;
    notifyListeners();

    return appointmentListPets;
  }

  //CREATE APPOINTMENT
  Future create(
    String date,
    String hour,
    int idPet,
    int idUser,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> appointmentData = {
      'date': date,
      'hour': hour,
      'idPet': idPet,
      'idUser': idUser,
    };

    final url = Uri.http(_baseUrl, '/api/user/appointment');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(appointmentData),
    );
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {}
    return resp.statusCode.toString();
  }

  //DELETE APPOINTMENT
  deleteAppointment(int id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/all/appointment/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }
}