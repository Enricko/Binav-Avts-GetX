/// message : "Ip Kapal successfully created."
/// status : 201

class AddIpVessel {
  AddIpVessel({
      String? message, 
      num? status,}){
    _message = message;
    _status = status;
}

  AddIpVessel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
  }
  String? _message;
  num? _status;
AddIpVessel copyWith({  String? message,
  num? status,
}) => AddIpVessel(  message: message ?? _message,
  status: status ?? _status,
);
  String? get message => _message;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    return map;
  }

}