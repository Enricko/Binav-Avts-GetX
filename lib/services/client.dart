import 'package:binav_avts_getx/model/get_client_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

class ClientService extends GetConnect {
  
  Future<GetClientResponse> getData(String token, int page, int perpage) async {
    var response = await get("${InitService.baseUrlApi}client?page=$page&per_page=$perpage", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }
}
