class GetKapalCoor {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  List<Data>? data;

  GetKapalCoor(
      {this.message,
      this.status,
      this.perpage,
      this.page,
      this.total,
      this.data});

  GetKapalCoor.fromJson(Map<String, dynamic> json) {
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
  String? idClient;
  String? callSign;
  String? flag;
  String? kelas;
  String? builder;
  bool? status;
  String? size;
  String? yearBuilt;
  String? xmlFile;
  String? image;
  Coor? coor;

  Data(
      {this.idClient,
      this.callSign,
      this.flag,
      this.kelas,
      this.builder,
      this.status,
      this.size,
      this.yearBuilt,
      this.xmlFile,
      this.image,
      this.coor});

  Data.fromJson(Map<String, dynamic> json) {
    idClient = json['id_client'];
    callSign = json['call_sign'];
    flag = json['flag'];
    kelas = json['kelas'];
    builder = json['builder'];
    status = json['status'];
    size = json['size'];
    yearBuilt = json['year_built'];
    xmlFile = json['xml_file'];
    image = json['image'];
    coor = json['coor'] != null ? new Coor.fromJson(json['coor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_client'] = this.idClient;
    data['call_sign'] = this.callSign;
    data['flag'] = this.flag;
    data['kelas'] = this.kelas;
    data['builder'] = this.builder;
    data['status'] = this.status;
    data['size'] = this.size;
    data['year_built'] = this.yearBuilt;
    data['xml_file'] = this.xmlFile;
    data['image'] = this.image;
    if (this.coor != null) {
      data['coor'] = this.coor!.toJson();
    }
    return data;
  }
}

class Coor {
  int? idCoor;
  double? defaultHeading;
  CoorGga? coorGga;
  CoorHdt? coorHdt;
  CoorVtg? coorVtg;

  Coor(
      {this.idCoor,
      this.defaultHeading,
      this.coorGga,
      this.coorHdt,
      this.coorVtg});

  Coor.fromJson(Map<String, dynamic> json) {
    idCoor = json['id_coor'];
    defaultHeading = json['default_heading'];
    coorGga = json['coor_gga'] != null
        ? new CoorGga.fromJson(json['coor_gga'])
        : null;
    coorHdt = json['coor_hdt'] != null
        ? new CoorHdt.fromJson(json['coor_hdt'])
        : null;
    coorVtg = json['coor_vtg'] != null
        ? new CoorVtg.fromJson(json['coor_vtg'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coor'] = this.idCoor;
    data['default_heading'] = this.defaultHeading;
    if (this.coorGga != null) {
      data['coor_gga'] = this.coorGga!.toJson();
    }
    if (this.coorHdt != null) {
      data['coor_hdt'] = this.coorHdt!.toJson();
    }
    if (this.coorVtg != null) {
      data['coor_vtg'] = this.coorVtg!.toJson();
    }
    return data;
  }
}

class CoorGga {
  double? latitude;
  double? longitude;
  String? gpsQualityIndicator;

  CoorGga({this.latitude, this.longitude, this.gpsQualityIndicator});

  CoorGga.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    gpsQualityIndicator = json['gps_quality_indicator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['gps_quality_indicator'] = this.gpsQualityIndicator;
    return data;
  }
}

class CoorHdt {
  int? idCoorHdt;
  double? headingDegree;

  CoorHdt({this.idCoorHdt, this.headingDegree});

  CoorHdt.fromJson(Map<String, dynamic> json) {
    idCoorHdt = json['id_coor_hdt'];
    headingDegree = json['heading_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coor_hdt'] = this.idCoorHdt;
    data['heading_degree'] = this.headingDegree;
    return data;
  }
}

class CoorVtg {
  int? idCoorVtg;
  double? speedInKnots;

  CoorVtg({this.idCoorVtg, this.speedInKnots});

  CoorVtg.fromJson(Map<String, dynamic> json) {
    idCoorVtg = json['id_coor_vtg'];
    speedInKnots = json['speed_in_knots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coor_vtg'] = this.idCoorVtg;
    data['speed_in_knots'] = this.speedInKnots;
    return data;
  }
}