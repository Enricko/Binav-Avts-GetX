import 'package:binav_avts_getx/controller/table/kapal/kapal_form.dart';
import 'package:binav_avts_getx/model/get_client_response.dart';
import 'package:binav_avts_getx/services/client.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import "package:responsive_ui/responsive_ui.dart";
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/table/kapal/kapal.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_text_field.dart';

class AddFormKapal extends StatelessWidget {
  AddFormKapal({super.key});

  final _formKey = GlobalKey<FormState>();
  var formController = Get.put(KapalFormController());

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
                          "Add Vessel",
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
                        Get.delete<KapalFormController>();
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
                    Divider(),
                    Text(
                      "Detail Vessel",
                      style: Constants.labelstyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FutureBuilder<GetClientResponse>(
                        future: ClientService().getData(GetStorage().read("userToken"), 1, 10000),
                        builder: (context, snapshot) {
                          return DropDownTextField(
                            controller: formController.idClientController,
                            dropDownList: [
                              if (snapshot.connectionState == ConnectionState.done ||
                                  snapshot.hasData)
                                if (snapshot.data!.data!.length > 0)
                                  for (var x in snapshot.data!.data!)
                                    DropDownValueModel(
                                        name: '${x.user!.name} - ${x.idClient}',
                                        value: "${x.idClient}"),
                            ],
                            clearOption: false,
                            enableSearch: true,
                            textStyle: const TextStyle(color: Colors.black),
                            searchDecoration:
                                const InputDecoration(hintText: "enter your custom hint text here"),
                            validator: (value) {
                              if (value == null || value == "" || value.isEmpty) {
                                return "Required field";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              print(formController.idClientController.dropDownValue!.value
                                  .toString());
                              // idClientValue = clientController.dropDownValue!.value.toString();
                              // SingleValueDropDownController(data: DropDownValueModel(value: "${data['role']}", name: "${data['role']}"))
                            },
                            textFieldDecoration: InputDecoration(
                              labelText: "Choose Client",
                              labelStyle: Constants.labelstyle,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black38)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.redAccent)),
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
                      controller: formController.callSignController,
                      label: 'Call Sign',
                      hint: 'Enter the Call Sign',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Call Sign field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.flagController,
                      label: 'Flag',
                      hint: 'Enter the Flag',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Flag field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.kelasController,
                      label: 'Class',
                      hint: 'Enter the Class',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Class field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.builderController,
                      label: 'Builder',
                      hint: 'Enter the Builder',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Builder field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.yearBuiltController,
                      label: 'Year Built',
                      hint: 'Enter the Year Built',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Year Built field is required.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    CustomTextField(
                      controller: formController.headingdirectionController,
                      label: 'Heading Direction',
                      hint: 'Enter a value less than 360°',
                      suffix: "Degress",
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Heading Direction is required.";
                        }
                        if (int.parse(value) < 0 || int.parse(value) > 360) {
                          return "The Heading Direction more than 360.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownSearch<String>(
                        dropdownBuilder: (context, selectedItem) => Text(
                          selectedItem ?? "Choose the Vessel Size",
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "The Ukuran Kapal field is required.";
                          }
                          return null;
                        },
                        popupProps: PopupPropsMultiSelection.dialog(
                          fit: FlexFit.loose,
                          itemBuilder: (context, item, isSelected) => ListTile(
                            title: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Vessel Size",
                            hintText: "Vessel Size",
                            labelStyle: Constants.labelstyle,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.black38)),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                            contentPadding: const EdgeInsets.fromLTRB(8, 3, 1, 3),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        items: [
                          "Small",
                          "Medium",
                          "Large",
                        ],
                        onChanged: (value) {
                          formController.vesselSize.value = value!;
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    ///upload file
                    Divider(),
                    Text(
                      "Upload File",
                      style: Constants.labelstyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            readOnly: true,
                            style: const TextStyle(fontSize: 14),
                            controller: formController.filePickerController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(8, 3, 1, 3),
                                hintText: 'File Name',
                                // labelText: 'File Name',
                                // labelStyle: Constants.labelstyle,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black38)),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black38)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                filled: true,
                                fillColor: Colors.white),
                          ),
                          // CustomTextField(
                          //   readOnly: true,
                          //   controller: formController.filePickerController,
                          //   hint: 'File Name',
                          //   type: TextInputType.text,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty || value == "") {
                          //       return "The File field is required.";
                          //     }
                          //     return null;
                          //   },
                          // ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                              // size: 24.0,
                            ),
                            label: const Text('XML File Only',
                                style: TextStyle(fontSize: 14.0, color: Colors.white)),
                            onPressed: () {
                              formController.pickFile();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              minimumSize: const Size(122, 48),
                              maximumSize: const Size(122, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Text(
                      "Upload Image",
                      style: Constants.labelstyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Obx(
                          () {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: formController.file_1.value == null
                                  ? Image.asset("assets/add_file_icon.png")
                                  : kIsWeb
                                      ? Image.memory(
                                          formController.webImage_1.value!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          formController.file_1.value!,
                                          fit: BoxFit.fill,
                                        ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: context.width,
                      // height: 300,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.white,
                          // size: 24.0,
                        ),
                        label: const Text('Pick Image',
                            style: TextStyle(fontSize: 14.0, color: Colors.white)),
                        onPressed: () {
                          formController.pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          // minimumSize: const Size(122, 48),
                          // maximumSize: const Size(122, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    Text(
                      "Status",
                      style: Constants.labelstyle,
                    ),
                    SizedBox(
                      height: 10,
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
                                await Get.find<KapalTableController>().getKapalData();
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
