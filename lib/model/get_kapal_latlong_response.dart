class GetKapalLatlongResponse {
  String? message;
  int? status;
  int? perpage;
  int? page;
  int? total;
  String? callSign;
  List<Data>? data;

  GetKapalLatlongResponse(
      {this.message,
      this.status,
      this.perpage,
      this.page,
      this.total,
      this.callSign,
      this.data});

  GetKapalLatlongResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    perpage = json['perpage'];
    page = json['page'];
    total = json['total'];
    callSign = json['call_sign'];
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
    data['call_sign'] = this.callSign;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? idCoor;
  double? defaultHeading;
  double? latitude;
  double? longitude;
  double? headingDegree;

  Data(
      {this.idCoor,
      this.defaultHeading,
      this.latitude,
      this.longitude,
      this.headingDegree});

  Data.fromJson(Map<String, dynamic> json) {
    idCoor = json['id_coor'];
    defaultHeading = json['default_heading'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    headingDegree = json['heading_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coor'] = this.idCoor;
    data['default_heading'] = this.defaultHeading;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['heading_degree'] = this.headingDegree;
    return data;
  }
}