class Appointment {
  int? id;
  int? idPet;
  int? idUser;
  String? hour;
  String? date;

  Appointment({this.id, this.idPet, this.idUser, this.hour, this.date});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPet = json['idPet'];
    idUser = json['idUser'];
    hour = json['hour'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idPet'] = this.idPet;
    data['idUser'] = this.idUser;
    data['hour'] = this.hour;
    data['date'] = this.date;
    return data;
  }
}