
class GetMappingResponse {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetMappingResponse({this.message, this.status, this.perpage, this.page, this.total, this.data});

  GetMappingResponse.fromJson(Map<String, dynamic> json) {
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
  int? idMapping;
  String? name;
  String? file;
  bool? status;

  Data({this.idClient, this.idMapping, this.name, this.file, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id_client"] is String) {
      idClient = json["id_client"];
    }
    if(json["id_mapping"] is int) {
      idMapping = json["id_mapping"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["file"] is String) {
      file = json["file"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_client"] = idClient;
    _data["id_mapping"] = idMapping;
    _data["name"] = name;
    _data["file"] = file;
    _data["status"] = status;
    return _data;
  }
}