import 'dart:convert';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'services.dart';

class AppointmentService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.7:8080';
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

  //DELETE APPOINTEMENT
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