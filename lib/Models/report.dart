class Report {
  int? id;
  int? idUser;
  int? idVeterinary;
  String? description;

  Report({this.id, this.idUser, this.idVeterinary, this.description});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['idUser'];
    idVeterinary = json['idVeterinary'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['idVeterinary'] = this.idVeterinary;
    data['description'] = this.description;
    return data;
  }
}