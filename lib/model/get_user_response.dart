
class GetUserResponse {
  String? message;
  int? status;
  List<Data>? data;

  GetUserResponse({this.message, this.status, this.data});

  GetUserResponse.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? idUser;
  dynamic idClient;
  String? name;
  String? email;
  String? level;

  Data({this.idUser, this.idClient, this.name, this.email, this.level});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id_user"] is String) {
      idUser = json["id_user"];
    }
    idClient = json["id_client"];
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["level"] is String) {
      level = json["level"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_user"] = idUser;
    _data["id_client"] = idClient;
    _data["name"] = name;
    _data["email"] = email;
    _data["level"] = level;
    return _data;
  }
}