import 'dart:convert';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'services.dart';

class PetService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.10:8080';
  bool isLoading = true;
  List<Pet> pets = [];
  String pet = "";
  Pet p = Pet();
  final storage = const FlutterSecureStorage();

// GET PETS
  Future<List> getListPets() async {
    pets.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/veterinary/pets');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Pet> petList = decodedResp
        .map((e) => Pet(
              id: e['id'],
              idUser: e['idUser'],
              age: e['age'],
              name: e['name'],
              animal: e['animal'],
              breed: e['breed'],
            ))
        .toList();
    pets = petList;

    isLoading = false;
    notifyListeners();

    return petList;
  }

  //GET USER PETS
  getPetsUser(String id) async {
    pets.clear();
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/pets/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Pet> petList = decodedResp
        .map((e) => Pet(
              id: e['id'],
              idUser: e['idUser'],
              age: e['age'],
              name: e['name'],
              animal: e['animal'],
              breed: e['breed'],
            ))
        .toList();

    pets = petList;
    isLoading = false;
    notifyListeners();

    return petList;
  }

//GET Pet
  Future<Pet> getPet(String id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/all/pets/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    Pet pet = Pet(
      id: decodedResp['id'],
      idUser: decodedResp['idUser'],
      age: decodedResp['age'],
      name: decodedResp['name'],
      animal: decodedResp['animal'],
      breed: decodedResp['breed'],
    );

    p = pet;

    isLoading = false;
    notifyListeners();
    return pet;
  }

// CREATE PET
  Future create(
    int age,
    String animal,
    String breed,
    String name,
    int idUser,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> petData = {
      'age': age,
      'animal': animal,
      'breed': breed,
      'name': name,
      'idUser': idUser,
    };

    final url = Uri.http(_baseUrl, '/api/veterinary/pet');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(petData),
    );
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {}
    return resp.statusCode.toString();
  }

  //UPDATE PET
  Future<String?> update(
      int id,
      int age, 
      String name, 
      String animal, 
      String breed
      ) async {
    String? token = await AuthService().readToken();
    final Map<String, dynamic> authData = {
      'age': age,
      'name': name,
      'animal': animal,
      'breed': breed,
    };

    final url = Uri.http(_baseUrl, '/api/veterinary/pet/$id');
    final resp = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (resp.statusCode == 200) {
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (resp.statusCode.toString());
    } else {
      return (resp.statusCode.toString());
    }
  }

  //  DELETE PET
  deletePet(int id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/veterinary/pet/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }
}
