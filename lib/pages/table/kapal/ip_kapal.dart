import 'dart:async';

import 'package:binav_avts_getx/controller/table/kapal/ip_kapal.dart';
import 'package:binav_avts_getx/model/get_ip_vessel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/table/kapal/kapal.dart';
import '../../../utils/alerts.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_text_field.dart';

class IpKapalPage extends StatelessWidget {
  IpKapalPage({super.key, required this.callSign});
  final String callSign;
  var controller = Get.put(IpTableController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.getIpKapal(callSign);
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width <= 540 ? width / 1.4 : width / 1.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Upload Ip & Port (${callSign})",
                  style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 480,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            controller: controller.ipController,
                            hint: 'IP',
                            type: TextInputType.text,
                            inputFormatters: [
                              MyInputFormatters.ipAddressInputFilter(),
                              LengthLimitingTextInputFormatter(15),
                              IpAddressInputFormatter()
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "") {
                                return "The IP field is required.";
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 14),
                                    controller: controller.portController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty || value == "") {
                                        return "The Port field is required.";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(8, 3, 1, 3),
                                        labelText: "Port",
                                        labelStyle: Constants.labelstyle,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(width: 1, color: Colors.blueAccent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(width: 1, color: Colors.black38)),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(width: 1, color: Colors.redAccent)),
                                        focusedErrorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(width: 1, color: Colors.redAccent)),
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 150,
                                child: DropdownSearch<String>(
                                  selectedItem: controller.type.value,
                                  dropdownBuilder: (context, selectedItem) => Text(
                                    selectedItem ?? "",
                                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return "The Type field is required.";
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
                                      labelText: "Type",
                                      labelStyle: Constants.labelstyle,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.black38)),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(width: 1, color: Colors.redAccent)),
                                      focusedErrorBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(width: 1, color: Colors.redAccent)),
                                      contentPadding: const EdgeInsets.fromLTRB(8, 3, 1, 3),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                  items: const [
                                    "all",
                                    "gga",
                                    "hdt",
                                    "vtg",
                                  ],
                                  onChanged: (value) {
                                    controller.type.value = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IgnorePointer(
                                ignoring: controller.ignorePointer.value,
                                child: ElevatedButton(
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
                                            await controller
                                                .addIpKapal(callSign)
                                                .then((value) async {
                                              if (value) {
                                                await Get.find<IpTableController>()
                                                    .getIpKapal(callSign);
                                              }
                                            });
                                          }
                                        },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Obx(
                          () => controller.isLoad.value
                              ? Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                )
                              : DataTable(
                                  headingRowColor: MaterialStateProperty.all(Color(0xffd3d3d3)),
                                  columns: const [
                                    DataColumn(label: SizedBox(width: 210, child: Text("IP"))),
                                    DataColumn(label: Text("Port")),
                                    DataColumn(label: Text("Type")),
                                    DataColumn(label: Text("Action")),
                                  ],
                                  rows: controller.dataIp!.map(
                                    (value) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(value.ip!)),
                                          DataCell(Text(value.port!.toString())),
                                          DataCell(Text(value.typeIp!)),
                                          DataCell(
                                            Tooltip(
                                              message: "Delete",
                                              child: IconButton(
                                                onPressed: () {
                                                  Alerts.showAlertYesNo(
                                                      title:
                                                          "Are you sure you want to delete this data?",
                                                      onPressYes: () async {
                                                        // if (!ignorePointer) {
                                                        //   setState(() {
                                                        //     ignorePointer = true;
                                                        //     ignorePointerTimer = Timer(const Duration(seconds: 3), () {
                                                        //       setState(() {
                                                        //         ignorePointer = false;
                                                        //       });
                                                        //     });
                                                        //   });
                                                        //   EasyLoading.show(status: "Loading...");
                                                        //   try {
                                                        //     SharedPreferences pref = await SharedPreferences.getInstance();
                                                        //     IpKapalDataService()
                                                        //         .deleteIpKapal(
                                                        //             token: pref.getString("token")!,
                                                        //             idIpKapal: value.idIpKapal.toString())
                                                        //         .then((val) {
                                                        //       if (val.status == 200) {
                                                        //         EasyLoading.showSuccess(val.message!,
                                                        //             duration: const Duration(seconds: 3), dismissOnTap: true);
                                                        //         Navigator.pop(context);
                                                        //       } else {
                                                        //         EasyLoading.showError(val.message!,
                                                        //             duration: const Duration(seconds: 3), dismissOnTap: true);
                                                        //         Navigator.pop(context);
                                                        //       }
                                                        //     });
                                                        //   } catch (e) {
                                                        //     print(e);
                                                        //     EasyLoading.showError(e.toString());
                                                        //   }
                                                        // }
                                                      },
                                                      onPressNo: () {
                                                        Navigator.pop(context);
                                                      },
                                                      context: context);
                                                },
                                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyInputFormatters {
  static TextInputFormatter ipAddressInputFilter() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }
}

class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int dotCounter = 0;
    var buffer = StringBuffer();
    String ipField = "";

    for (int i = 0; i < text.length; i++) {
      if (dotCounter < 4) {
        if (text[i] != ".") {
          ipField += text[i];
          if (ipField.length < 3) {
            buffer.write(text[i]);
          } else if (ipField.length == 3) {
            if (int.parse(ipField) <= 255) {
              buffer.write(text[i]);
            } else {
              if (dotCounter < 3) {
                buffer.write(".");
                dotCounter++;
                buffer.write(text[i]);
                ipField = text[i];
              }
            }
          } else if (ipField.length == 4) {
            if (dotCounter < 3) {
              buffer.write(".");
              dotCounter++;
              buffer.write(text[i]);
              ipField = text[i];
            }
          }
        } else {
          if (dotCounter < 3) {
            buffer.write(".");
            dotCounter++;
            ipField = "";
          }
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}
