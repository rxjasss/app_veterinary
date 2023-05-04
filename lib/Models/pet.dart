class Pet {
  int? id;
  int? idUser;
  int? age;
  String? name;
  String? animal;
  String? breed;

  Pet({this.id, this.idUser, this.age, this.name, this.animal, this.breed});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    age = json['age'];
    name = json['name'];
    animal = json['animal'];
    breed = json['breed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['age'] = this.age;
    data['name'] = this.name;
    data['animal'] = this.animal;
    data['breed'] = this.breed;
    return data;
  }
}