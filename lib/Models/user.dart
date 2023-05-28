class User {
  int? id;
  String? username;
  String? name;
  String? surname;
  String? password;
  bool? enabled;
  String? role;
  String? token;

  User(
      {this.id,
      this.username,
      this.name,
      this.surname,
      this.password,
      this.enabled,
      this.role,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    surname = json['surname'];
    password = json['password'];
    enabled = json['enabled'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['password'] = this.password;
    data['enabled'] = this.enabled;
    data['role'] = this.role;
    data['token'] = this.token;
    return data;
  }
  
}
