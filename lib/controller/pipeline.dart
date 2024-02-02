import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/get_pipeline_response.dart';
import '../services/pipeline.dart';

class PipelineController extends GetxController {
  Rx<StreamSocketPipeline> streamSocketPipeline = StreamSocketPipeline().obs;

  void socketAllMapping() {
    IO.Socket socket = IO.io('http://127.0.0.1:5000/mapping', IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) => print('connect All'));

    socket.on('mapping', (data) {
      var response = GetPipelineResponse.fromJson(data);

      streamSocketPipeline.value.addResponseAll(response);
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
    streamSocketPipeline.value.dispose();
  }
}
