import 'package:binav_avts_getx/controller/table/client/client.dart';
import 'package:binav_avts_getx/controller/table/client/client_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/custom_text_field.dart';

class AddFormClient extends StatelessWidget {
  AddFormClient({super.key});
  final _formKey = GlobalKey<FormState>();
  var formController = Get.put(ClientFormController());

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
                          "Add Client",
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
                        Get.delete<ClientFormController>();
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
                    CustomTextField(
                      controller: formController.emailController,
                      hint: 'Email',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Email field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.passwordController,
                      hint: 'Password',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Class field is required.";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: formController.passwordConfirmationtController,
                      hint: 'Password Confirmation',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "The Password Con field is required.";
                        }
                        return null;
                      },
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
                                await Get.find<ClientTableController>().getClientData();
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
