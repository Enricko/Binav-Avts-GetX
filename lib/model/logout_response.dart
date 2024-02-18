/// message : "Successfully logged out."
/// status : 200

class LogoutResponse {
  LogoutResponse({
      String? message, 
      num? status,}){
    _message = message;
    _status = status;
}

  LogoutResponse.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
  }
  String? _message;
  num? _status;
LogoutResponse copyWith({  String? message,
  num? status,
}) => LogoutResponse(  message: message ?? _message,
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