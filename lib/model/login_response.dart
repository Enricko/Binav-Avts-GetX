
class LoginResponse {
  String? message;
  String? token;
  int? status;

  LoginResponse({this.message, this.token, this.status});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["token"] is String) {
      token = json["token"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["token"] = token;
    _data["status"] = status;
    return _data;
  }

  then(Null Function(dynamic value) param0) {}
}