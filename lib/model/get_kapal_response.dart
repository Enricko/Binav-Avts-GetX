
class GetKapalResponse {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetKapalResponse({this.message, this.status, this.perpage, this.page, this.total, this.data});

  GetKapalResponse.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    status = json["status"];
    perpage = json["perpage"];
    page = json["page"];
    total = json["total"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
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
  String? callSign;
  String? flag;
  String? kelas;
  String? builder;
  String? size;
  bool? status;
  String? xmlFile;
  String? yearBuilt;
  String? createdAt;
  String? updatedAt;

  Data({this.idClient, this.callSign, this.flag, this.kelas, this.builder, this.size, this.status, this.xmlFile, this.yearBuilt, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    idClient = json["id_client"];
    callSign = json["call_sign"];
    flag = json["flag"];
    kelas = json["kelas"];
    builder = json["builder"];
    size = json["size"];
    status = json["status"];
    xmlFile = json["xml_file"];
    yearBuilt = json["year_built"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_client"] = idClient;
    _data["call_sign"] = callSign;
    _data["flag"] = flag;
    _data["kelas"] = kelas;
    _data["builder"] = builder;
    _data["size"] = size;
    _data["status"] = status;
    _data["xml_file"] = xmlFile;
    _data["year_built"] = yearBuilt;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}