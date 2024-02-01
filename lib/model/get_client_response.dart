
class GetClientResponse {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetClientResponse({this.message, this.status, this.perpage, this.page, this.total, this.data});

  GetClientResponse.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["perpage"] is int) {
      perpage = json["perpage"];
    }
    if(json["page"] is int) {
      page = json["page"];
    }
    if(json["total"] is int) {
      total = json["total"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    _data["perpage"] = perpage;
    _data["page"] = page;
    _data["total"] = total;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? idClient;
  bool? status;
  User? user;
  String? createdAt;
  String? updatedAt;

  Data({this.idClient, this.status, this.user, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id_client"] is String) {
      idClient = json["id_client"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_client"] = idClient;
    _data["status"] = status;
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class User {
  String? idUser;
  dynamic idClient;
  String? name;
  String? email;
  String? level;

  User({this.idUser, this.idClient, this.name, this.email, this.level});

  User.fromJson(Map<String, dynamic> json) {
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