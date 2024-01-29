
class GetKapalCoor {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetKapalCoor({this.message, this.status, this.perpage, this.page, this.total, this.data});

  GetKapalCoor.fromJson(Map<String, dynamic> json) {
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
  String? callSign;
  String? flag;
  String? kelas;
  String? size;
  bool? status;
  int? idCoor;
  CoorGga? coorGga;
  CoorHdt? coorHdt;

  Data({this.idClient, this.callSign, this.flag, this.kelas, this.size, this.status, this.idCoor, this.coorGga, this.coorHdt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id_client"] is String) {
      idClient = json["id_client"];
    }
    if(json["call_sign"] is String) {
      callSign = json["call_sign"];
    }
    if(json["flag"] is String) {
      flag = json["flag"];
    }
    if(json["kelas"] is String) {
      kelas = json["kelas"];
    }
    if(json["size"] is String) {
      size = json["size"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["id_coor"] is int) {
      idCoor = json["id_coor"];
    }
    if(json["coor_gga"] is Map) {
      coorGga = json["coor_gga"] == null ? null : CoorGga.fromJson(json["coor_gga"]);
    }
    if(json["coor_hdt"] is Map) {
      coorHdt = json["coor_hdt"] == null ? null : CoorHdt.fromJson(json["coor_hdt"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_client"] = idClient;
    _data["call_sign"] = callSign;
    _data["flag"] = flag;
    _data["kelas"] = kelas;
    _data["size"] = size;
    _data["status"] = status;
    _data["id_coor"] = idCoor;
    if(coorGga != null) {
      _data["coor_gga"] = coorGga?.toJson();
    }
    if(coorHdt != null) {
      _data["coor_hdt"] = coorHdt?.toJson();
    }
    return _data;
  }
}

class CoorHdt {
  dynamic idCoorHdt;
  dynamic headingDegree;

  CoorHdt({this.idCoorHdt, this.headingDegree});

  CoorHdt.fromJson(Map<String, dynamic> json) {
    idCoorHdt = json["id_coor_hdt"];
    headingDegree = json["heading_degree"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_coor_hdt"] = idCoorHdt;
    _data["heading_degree"] = headingDegree;
    return _data;
  }
}

class CoorGga {
  double? latitude;
  double? longitude;

  CoorGga({this.latitude, this.longitude});

  CoorGga.fromJson(Map<String, dynamic> json) {
    if(json["latitude"] is double) {
      latitude = json["latitude"];
    }
    if(json["longitude"] is double) {
      longitude = json["longitude"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    return _data;
  }
}