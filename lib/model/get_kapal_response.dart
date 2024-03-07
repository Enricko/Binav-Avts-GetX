/// message : "Data Kapal Ditemukan"
/// status : 200
/// perpage : 10
/// page : 1
/// total : 3
/// data : [{"call_sign":"as1112","flag":"ind","kelas":"ssadas","builder":"asdwww","size":"small","status":true,"xml_file":"","image":"2024_03_04_19_10_43_as1112.png","year_built":"1232","heading_direction":232,"created_at":"2024-03-04T19:10:43","updated_at":"2024-03-04T19:10:43","client":{"id_client":"AlH0sZJEEK7BUApQAaHJm1spfmYQ28KmvYs","status":true,"user":{"id_user":"7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82","id_client":null,"name":"bahrunsyahtan","email":"bahrunsyahtan@gmail.com","level":"owner"},"created_at":"2024-02-18T11:17:48","updated_at":"2024-02-18T11:17:48"}},{"call_sign":"AWB. Rajawali Natuna","flag":"indonesia","kelas":"BKI","builder":"batam","size":"large","status":true,"xml_file":"2024_02_24_17_43_07_AWB. Rajawali Natuna.xml","image":"2024_02_27_07_35_31_AWB. Rajawali Natuna.png","year_built":"2017","heading_direction":null,"created_at":"2024-01-19T17:23:17","updated_at":"2024-02-27T07:35:31","client":{"id_client":"AlH0sZJEEK7BUApQAaHJm1spfmYQ28KmvYs","status":true,"user":{"id_user":"7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82","id_client":null,"name":"bahrunsyahtan","email":"bahrunsyahtan@gmail.com","level":"owner"},"created_at":"2024-02-18T11:17:48","updated_at":"2024-02-18T11:17:48"}},{"call_sign":"SPO Robin","flag":"indo","kelas":"BKI","builder":"Batam","size":"medium","status":true,"xml_file":"2024_02_18_13_44_17_YBDU07.xml","image":"2024_02_27_07_37_12_SPO Robin.png","year_built":"2018","heading_direction":null,"created_at":"2024-02-18T13:44:17","updated_at":"2024-02-27T07:37:12","client":{"id_client":"AlH0sZJEEK7BUApQAaHJm1spfmYQ28KmvYs","status":true,"user":{"id_user":"7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82","id_client":null,"name":"bahrunsyahtan","email":"bahrunsyahtan@gmail.com","level":"owner"},"created_at":"2024-02-18T11:17:48","updated_at":"2024-02-18T11:17:48"}}]

class GetKapalResponse {
  GetKapalResponse({
      String? message, 
      num? status, 
      num? perpage, 
      num? page, 
      num? total, 
      List<Data>? data,}){
    _message = message;
    _status = status;
    _perpage = perpage;
    _page = page;
    _total = total;
    _data = data;
}

  GetKapalResponse.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _perpage = json['perpage'];
    _page = json['page'];
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
  num? _perpage;
  num? _page;
  num? _total;
  List<Data>? _data;
GetKapalResponse copyWith({  String? message,
  num? status,
  num? perpage,
  num? page,
  num? total,
  List<Data>? data,
}) => GetKapalResponse(  message: message ?? _message,
  status: status ?? _status,
  perpage: perpage ?? _perpage,
  page: page ?? _page,
  total: total ?? _total,
  data: data ?? _data,
);
  String? get message => _message;
  num? get status => _status;
  num? get perpage => _perpage;
  num? get page => _page;
  num? get total => _total;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    map['perpage'] = _perpage;
    map['page'] = _page;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// call_sign : "as1112"
/// flag : "ind"
/// kelas : "ssadas"
/// builder : "asdwww"
/// size : "small"
/// status : true
/// xml_file : ""
/// image : "2024_03_04_19_10_43_as1112.png"
/// year_built : "1232"
/// heading_direction : 232
/// created_at : "2024-03-04T19:10:43"
/// updated_at : "2024-03-04T19:10:43"
/// client : {"id_client":"AlH0sZJEEK7BUApQAaHJm1spfmYQ28KmvYs","status":true,"user":{"id_user":"7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82","id_client":null,"name":"bahrunsyahtan","email":"bahrunsyahtan@gmail.com","level":"owner"},"created_at":"2024-02-18T11:17:48","updated_at":"2024-02-18T11:17:48"}

class Data {
  Data({
      String? callSign, 
      String? flag, 
      String? kelas, 
      String? builder, 
      String? size, 
      bool? status, 
      String? xmlFile, 
      String? image, 
      String? yearBuilt, 
      int? headingDirection, 
      String? createdAt, 
      String? updatedAt, 
      Client? client,}){
    _callSign = callSign;
    _flag = flag;
    _kelas = kelas;
    _builder = builder;
    _size = size;
    _status = status;
    _xmlFile = xmlFile;
    _image = image;
    _yearBuilt = yearBuilt;
    _headingDirection = headingDirection;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _client = client;
}

  Data.fromJson(dynamic json) {
    _callSign = json['call_sign'];
    _flag = json['flag'];
    _kelas = json['kelas'];
    _builder = json['builder'];
    _size = json['size'];
    _status = json['status'];
    _xmlFile = json['xml_file'];
    _image = json['image'];
    _yearBuilt = json['year_built'];
    _headingDirection = json['heading_direction'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _client = json['client'] != null ? Client.fromJson(json['client']) : null;
  }
  String? _callSign;
  String? _flag;
  String? _kelas;
  String? _builder;
  String? _size;
  bool? _status;
  String? _xmlFile;
  String? _image;
  String? _yearBuilt;
  int? _headingDirection;
  String? _createdAt;
  String? _updatedAt;
  Client? _client;
Data copyWith({  String? callSign,
  String? flag,
  String? kelas,
  String? builder,
  String? size,
  bool? status,
  String? xmlFile,
  String? image,
  String? yearBuilt,
  int? headingDirection,
  String? createdAt,
  String? updatedAt,
  Client? client,
}) => Data(  callSign: callSign ?? _callSign,
  flag: flag ?? _flag,
  kelas: kelas ?? _kelas,
  builder: builder ?? _builder,
  size: size ?? _size,
  status: status ?? _status,
  xmlFile: xmlFile ?? _xmlFile,
  image: image ?? _image,
  yearBuilt: yearBuilt ?? _yearBuilt,
  headingDirection: headingDirection ?? _headingDirection,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  client: client ?? _client,
);
  String? get callSign => _callSign;
  String? get flag => _flag;
  String? get kelas => _kelas;
  String? get builder => _builder;
  String? get size => _size;
  bool? get status => _status;
  String? get xmlFile => _xmlFile;
  String? get image => _image;
  String? get yearBuilt => _yearBuilt;
  int? get headingDirection => _headingDirection;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Client? get client => _client;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['call_sign'] = _callSign;
    map['flag'] = _flag;
    map['kelas'] = _kelas;
    map['builder'] = _builder;
    map['size'] = _size;
    map['status'] = _status;
    map['xml_file'] = _xmlFile;
    map['image'] = _image;
    map['year_built'] = _yearBuilt;
    map['heading_direction'] = _headingDirection;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_client != null) {
      map['client'] = _client?.toJson();
    }
    return map;
  }

}

/// id_client : "AlH0sZJEEK7BUApQAaHJm1spfmYQ28KmvYs"
/// status : true
/// user : {"id_user":"7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82","id_client":null,"name":"bahrunsyahtan","email":"bahrunsyahtan@gmail.com","level":"owner"}
/// created_at : "2024-02-18T11:17:48"
/// updated_at : "2024-02-18T11:17:48"

class Client {
  Client({
      String? idClient, 
      bool? status, 
      User? user, 
      String? createdAt, 
      String? updatedAt,}){
    _idClient = idClient;
    _status = status;
    _user = user;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Client.fromJson(dynamic json) {
    _idClient = json['id_client'];
    _status = json['status'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _idClient;
  bool? _status;
  User? _user;
  String? _createdAt;
  String? _updatedAt;
Client copyWith({  String? idClient,
  bool? status,
  User? user,
  String? createdAt,
  String? updatedAt,
}) => Client(  idClient: idClient ?? _idClient,
  status: status ?? _status,
  user: user ?? _user,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get idClient => _idClient;
  bool? get status => _status;
  User? get user => _user;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_client'] = _idClient;
    map['status'] = _status;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id_user : "7tmSj69Yj55l6hHIAJw7lSxCL0qsm8C9R82"
/// id_client : null
/// name : "bahrunsyahtan"
/// email : "bahrunsyahtan@gmail.com"
/// level : "owner"

class User {
  User({
      String? idUser, 
      dynamic idClient, 
      String? name, 
      String? email, 
      String? level,}){
    _idUser = idUser;
    _idClient = idClient;
    _name = name;
    _email = email;
    _level = level;
}

  User.fromJson(dynamic json) {
    _idUser = json['id_user'];
    _idClient = json['id_client'];
    _name = json['name'];
    _email = json['email'];
    _level = json['level'];
  }
  String? _idUser;
  dynamic _idClient;
  String? _name;
  String? _email;
  String? _level;
User copyWith({  String? idUser,
  dynamic idClient,
  String? name,
  String? email,
  String? level,
}) => User(  idUser: idUser ?? _idUser,
  idClient: idClient ?? _idClient,
  name: name ?? _name,
  email: email ?? _email,
  level: level ?? _level,
);
  String? get idUser => _idUser;
  dynamic get idClient => _idClient;
  String? get name => _name;
  String? get email => _email;
  String? get level => _level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_user'] = _idUser;
    map['id_client'] = _idClient;
    map['name'] = _name;
    map['email'] = _email;
    map['level'] = _level;
    return map;
  }

}