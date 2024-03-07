import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../controller/table/kapal/kapal.dart';
import '../../../controller/table/kapal/kapal_form.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_text_field.dart';

class EditFormKapal extends StatelessWidget {
  EditFormKapal({super.key, required this.callSign});
  final String callSign;
  final _formKey = GlobalKey<FormState>();
  var controller = Get.put(KapalFormController());

  @override
  Widget build(BuildContext context) {
    controller.getUpdatedData(callSign);
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
                          "Edit Vessel",
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
                    CustomTextField(
                      controller: controller.callSignController,
                      label: "Call Sign",
                      hint: 'Call Sign',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Call Sign field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.flagController,
                      label: 'Flag',
                      hint: 'Flag',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Flag field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.kelasController,
                      label: "Class",
                      hint: 'Class',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Class field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.builderController,
                      label: "Builder",
                      hint: 'Builder',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Builder field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.yearBuiltController,
                      label: "Year Built",
                      hint: 'Year Built',
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
                      controller: controller.headingdirectionController,
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
                          selectedItem ?? controller.vesselSize.value,
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        // selectedItem: controller.vesselSize.value,

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
                        ),
                        items: [
                          "small",
                          "medium",
                          "large",
                        ],
                        onChanged: (value) {
                          controller.vesselSize.value = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                            controller: controller.filePickerController,
                            label: "File Name",
                            hint: 'File Name',
                            type: TextInputType.text,
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
                            label: const Text('Pilih File XML File Only', style: TextStyle(fontSize: 14.0)),
                            onPressed: () {
                              controller.pickFile();
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
                              child: controller.file_1.value == null
                                  ? Icon(Icons.image)
                                  : kIsWeb
                                      ? Image.memory(
                                          controller.webImage_1.value!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          controller.file_1.value!,
                                          fit: BoxFit.fill,
                                        ),
                            );
                          },
                        ),
                      ),
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
                          controller.pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
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
                      "Instalation",
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
                                  value: controller.isSwitched.value,
                                  onChanged: (bool value) {
                                    controller.isSwitched.value = value;
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
                  onPressed: controller.isLoad.value
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await controller.updateData(callSign).then((value)async{
                              if(value){
                                await Get.find<KapalTableController>().getKapalData();
                              }
                            });
                          }
                        },
                  child: controller.isLoad.value
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
