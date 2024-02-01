import 'package:binav_avts_getx/pages/table/add_form.dart';
import 'package:binav_avts_getx/pages/table/edit_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_flutter/pagination.dart';

import '../../controller/table/kapal.dart';
import '../../utils/alerts.dart';

class KapalTable extends StatelessWidget {
  KapalTable({super.key});
  var controller = Get.put(KapalTableController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width <= 540 ? context.width / 1.2 : context.width / 1.5,
      // height: Get.height,
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
                          "List Vessel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "Page ${controller.page.value} of ${controller.total_page.value}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Close the dialog
                      Get.back();
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
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
              onPressed: () {
                Get.dialog(Dialog(
                  child: AddFormKapal(),
                ));
              },
              child: const Text(
                "Add Vessel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => controller.isLoad.value
                        ? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : DataTable(
                            border: TableBorder.all(color: Colors.black, width: 1),
                            headingRowColor: MaterialStateProperty.all(const Color(0xffd3d3d3)),
                            columns: const [
                              DataColumn(label: Text("No.", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Call Sign", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Flag", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Class", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Builder", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Year Built", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Size", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("File XML", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Upload IP ", style: TextStyle(fontWeight: FontWeight.w800))),
                              DataColumn(label: Text("Action", style: TextStyle(fontWeight: FontWeight.w800))),
                            ],
                            // ignore: invalid_use_of_protected_member
                            rows: controller.data!.value.map((row) {
                              int numberedTable =
                                  // ignore: invalid_use_of_protected_member
                                  controller.data!.value.toList().indexWhere((e) => e.callSign == row.callSign) +
                                      1 * controller.page.value;
                              return DataRow(cells: [
                                DataCell(Text(numberedTable.toString())),
                                DataCell(Text(row.callSign!)),
                                DataCell(Text(row.flag!)),
                                DataCell(Text(row.kelas!)),
                                DataCell(Text(row.builder!)),
                                DataCell(Text(row.yearBuilt!)),
                                DataCell(Text(row.size!)),
                                DataCell(Text(row.xmlFile!)),
                                DataCell(Container()),
                                DataCell(Row(
                                  children: [
                                    Tooltip(
                                      message: "Edit",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Get.dialog(Dialog(
                                            child: EditFormKapal(callSign:row.callSign!),
                                          ));
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Delete",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: controller.isLoad.value
                                            ? null
                                            : () {
                                                Alerts.showAlertYesNo(
                                                  title: "Are you sure you want to delete this data?",
                                                  onPressYes: () async {
                                                    await controller
                                                        .deleteData(callSign: row.callSign!)
                                                        .then((_) async {
                                                      await controller.getKapalData();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  onPressNo: () {
                                                    Navigator.pop(context);
                                                  },
                                                  context: context,
                                                );
                                              },
                                      ),
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Pagination(
                numOfPages: controller.total_page.value,
                selectedPage: controller.page.value,
                pagesVisible: 7,
                onPageChanged: (value) async {
                  if (value != controller.page.value) {
                    await controller.getKapalData().then((_) {
                      controller.page.value = value;
                    });
                  }
                },
                nextIcon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 14,
                ),
                previousIcon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                  size: 14,
                ),
                activeTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                activeBtnStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                ),
                inactiveBtnStyle: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38),
                  )),
                ),
                inactiveTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
