class GetKapalResponse {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetKapalResponse(
      {this.message,
      this.status,
      this.perpage,
      this.page,
      this.total,
      this.data});

  GetKapalResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    perpage = json['perpage'];
    page = json['page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['perpage'] = this.perpage;
    data['page'] = this.page;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? callSign;
  String? flag;
  String? kelas;
  String? builder;
  String? size;
  bool? status;
  String? xmlFile;
  String? image;
  String? yearBuilt;
  String? createdAt;
  String? updatedAt;
  Client? client;

  Data(
      {this.callSign,
      this.flag,
      this.kelas,
      this.builder,
      this.size,
      this.status,
      this.xmlFile,
      this.image,
      this.yearBuilt,
      this.createdAt,
      this.updatedAt,
      this.client});

  Data.fromJson(Map<String, dynamic> json) {
    callSign = json['call_sign'];
    flag = json['flag'];
    kelas = json['kelas'];
    builder = json['builder'];
    size = json['size'];
    status = json['status'];
    xmlFile = json['xml_file'];
    image = json['image'];
    yearBuilt = json['year_built'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['call_sign'] = this.callSign;
    data['flag'] = this.flag;
    data['kelas'] = this.kelas;
    data['builder'] = this.builder;
    data['size'] = this.size;
    data['status'] = this.status;
    data['xml_file'] = this.xmlFile;
    data['image'] = this.image;
    data['year_built'] = this.yearBuilt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    return data;
  }
}

class Client {
  String? idClient;
  bool? status;
  User? user;
  String? createdAt;
  String? updatedAt;

  Client(
      {this.idClient, this.status, this.user, this.createdAt, this.updatedAt});

  Client.fromJson(Map<String, dynamic> json) {
    idClient = json['id_client'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_client'] = this.idClient;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  String? idUser;
  Null? idClient;
  String? name;
  String? email;
  String? level;

  User({this.idUser, this.idClient, this.name, this.email, this.level});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    idClient = json['id_client'];
    name = json['name'];
    email = json['email'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['id_client'] = this.idClient;
    data['name'] = this.name;
    data['email'] = this.email;
    data['level'] = this.level;
    return data;
  }
}