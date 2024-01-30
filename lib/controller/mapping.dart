import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/get_mapping_response.dart';
import '../services/mapping.dart';

class MappingController extends GetxController {
  Rx<StreamSocketMapping> streamSocketMapping = StreamSocketMapping().obs;

  void socketAllMapping() {
    IO.Socket socket = IO.io('http://127.0.0.1:5000/mapping', IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) => print('connect All'));

    socket.on('mapping', (data) {
      var response = GetMappingResponse.fromJson(data);

      streamSocketMapping.value.addResponseAll(response);
    });
    socket.onDisconnect((_) => print('disconnect All'));
  }

  @override
  void onInit() {
    super.onInit();
    socketAllMapping();
  }

  @override
  void onClose() {
    super.onClose();
    streamSocketMapping.value.dispose();
  }
}
