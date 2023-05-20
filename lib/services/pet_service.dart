import 'dart:convert';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'services.dart';

class PetService extends ChangeNotifier {
  final String _baseUrl = '192.168.2.9:8080';
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
    final url = Uri.http(_baseUrl, '/api/all/pets');
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
    String name,
    String description,
    String price,
    int idCategory,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
      'idCategory': idCategory,
    };

    final url = Uri.http(_baseUrl, '/api/admin/categories/$idCategory/product');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {}
  }

  //  DELETE PET
  deleteProduct(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/admin/products/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {}
  }

  // EDIT PET
}