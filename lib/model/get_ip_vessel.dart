class GetIpVessel {
  String? message;
  int? status;
  int? total;
  List<Data>? data;

  GetIpVessel({this.message, this.status, this.total, this.data});

  GetIpVessel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
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
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? idIpKapal;
  String? callSign;
  String? typeIp;
  String? ip;
  int? port;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.idIpKapal,
      this.callSign,
      this.typeIp,
      this.ip,
      this.port,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    idIpKapal = json['id_ip_kapal'];
    callSign = json['call_sign'];
    typeIp = json['type_ip'];
    ip = json['ip'];
    port = json['port'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_ip_kapal'] = this.idIpKapal;
    data['call_sign'] = this.callSign;
    data['type_ip'] = this.typeIp;
    data['ip'] = this.ip;
    data['port'] = this.port;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}