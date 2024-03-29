import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../controller/table/pipeline/pipeline.dart';
import '../../../controller/table/pipeline/pipeline_form.dart';
import '../../../model/get_client_response.dart';
import '../../../services/client.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_text_field.dart';

class AddFormPipeline extends StatelessWidget {
  AddFormPipeline({super.key});

  final _formKey = GlobalKey<FormState>();
  var formController = Get.put(PipelineFormController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: context.width <= 540 ? context.width / 1.3 : context.width / 1.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Pipeline",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // Close the dialog
                        Get.back();
                        Get.delete<PipelineFormController>();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black87,
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FutureBuilder<GetClientResponse>(
                        future: ClientService().getData(GetStorage().read("userToken"), 1, 10000),
                        builder: (context, snapshot) {
                          return DropDownTextField(
                            controller: formController.idClientController,
                            dropDownList: [
                              if (snapshot.connectionState == ConnectionState.done || snapshot.hasData)
                                if (snapshot.data!.data!.length > 0)
                                  for (var x in snapshot.data!.data!)
                                    DropDownValueModel(name: '${x.user!.name} - ${x.idClient}', value: "${x.idClient}"),
                            ],
                            clearOption: false,
                            enableSearch: true,
                            textStyle: const TextStyle(color: Colors.black),
                            searchDecoration: const InputDecoration(hintText: "enter your custom hint text here"),
                            validator: (value) {
                              if (value == null || value == "" || value.isEmpty) {
                                return "Required field";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              print(formController.idClientController.dropDownValue!.value.toString());
                              // idClientValue = clientController.dropDownValue!.value.toString();
                              // SingleValueDropDownController(data: DropDownValueModel(value: "${data['role']}", name: "${data['role']}"))
                            },
                            textFieldDecoration: InputDecoration(
                              labelText: "Choose Client",
                              labelStyle: Constants.labelstyle,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                              ),
                              enabledBorder:
                                  const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                              errorBorder:
                                  const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                              focusedErrorBorder:
                                  const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                              contentPadding: const EdgeInsets.fromLTRB(8, 3, 1, 3),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: formController.nameController,
                      hint: 'Name',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Name field is required.";
                        }
                        return null;
                      },
                    ),
                    Responsive(
                      children: [
                        Div(
                          divison: const Division(
                            colXS: 12,
                            colS: 6,
                            colM: 8,
                            colL: 9,
                            colXL: 9,
                          ),
                          child: CustomTextField(
                            readOnly: true,
                            controller: formController.filePickerController,
                            hint: 'File Name',
                            type: TextInputType.text,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty || value == "") {
                            //     return "The File field is required.";
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        Div(
                          divison: const Division(
                            colXS: 12,
                            colS: 6,
                            colM: 4,
                            colL: 3,
                            colXL: 3,
                          ),
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            label: const Text('Pilih File KML/KMZ File Only', style: TextStyle(fontSize: 14.0)),
                            onPressed: () {
                              formController.pickFile();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue,
                              minimumSize: const Size(122, 48),
                              maximumSize: const Size(122, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          const Text("Off/On"),
                          Obx(
                            () => SizedBox(
                              height: 40,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch(
                                  value: formController.isSwitched.value,
                                  onChanged: (bool value) {
                                    formController.isSwitched.value = value;
                                  },
                                  activeTrackColor: Colors.lightGreen,
                                  activeColor: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 25),
              child: Obx(
                () => ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: formController.isLoad.value
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await formController.addData().then((value) async {
                              if (value) {
                                await Get.find<PipelineTableController>().getPipelineData();
                              }
                            });
                          }
                        },
                  child: formController.isLoad.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
