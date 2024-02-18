/// message : "Data Ip Kapal Ditemukan."
/// status : 200
/// total : 1
/// data : [{"id_ip_kapal":1,"call_sign":"YDBU08","type_ip":"all","ip":"8.222.190.213","port":5018,"created_at":"2024-02-18T00:12:53","updated_at":"2024-02-18T00:12:53"}]

class GetIpVessel {
  GetIpVessel({
      String? message, 
      num? status, 
      num? total, 
      List<Data>? data,}){
    _message = message;
    _status = status;
    _total = total;
    _data = data;
}

  GetIpVessel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _total = json['total'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _message;
  num? _status;
  num? _total;
  List<Data>? _data;
GetIpVessel copyWith({  String? message,
  num? status,
  num? total,
  List<Data>? data,
}) => GetIpVessel(  message: message ?? _message,
  status: status ?? _status,
  total: total ?? _total,
  data: data ?? _data,
);
  String? get message => _message;
  num? get status => _status;
  num? get total => _total;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id_ip_kapal : 1
/// call_sign : "YDBU08"
/// type_ip : "all"
/// ip : "8.222.190.213"
/// port : 5018
/// created_at : "2024-02-18T00:12:53"
/// updated_at : "2024-02-18T00:12:53"

class Data {
  Data({
      num? idIpKapal, 
      String? callSign, 
      String? typeIp, 
      String? ip, 
      num? port, 
      String? createdAt, 
      String? updatedAt,}){
    _idIpKapal = idIpKapal;
    _callSign = callSign;
    _typeIp = typeIp;
    _ip = ip;
    _port = port;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _idIpKapal = json['id_ip_kapal'];
    _callSign = json['call_sign'];
    _typeIp = json['type_ip'];
    _ip = json['ip'];
    _port = json['port'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _idIpKapal;
  String? _callSign;
  String? _typeIp;
  String? _ip;
  num? _port;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? idIpKapal,
  String? callSign,
  String? typeIp,
  String? ip,
  num? port,
  String? createdAt,
  String? updatedAt,
}) => Data(  idIpKapal: idIpKapal ?? _idIpKapal,
  callSign: callSign ?? _callSign,
  typeIp: typeIp ?? _typeIp,
  ip: ip ?? _ip,
  port: port ?? _port,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get idIpKapal => _idIpKapal;
  String? get callSign => _callSign;
  String? get typeIp => _typeIp;
  String? get ip => _ip;
  num? get port => _port;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_ip_kapal'] = _idIpKapal;
    map['call_sign'] = _callSign;
    map['type_ip'] = _typeIp;
    map['ip'] = _ip;
    map['port'] = _port;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}