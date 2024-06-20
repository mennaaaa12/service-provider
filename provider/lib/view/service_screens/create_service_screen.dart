import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:worker/controller/CreateServiceController.dart';
import 'package:worker/noconnection.dart';

class CreateServiceScreen extends StatefulWidget {
  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final CreateServiceController controller = Get.put(CreateServiceController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  bool coverImagePicked = false;
  bool isLoading = false;
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    categoryController.clear();
    controller.coverImage = File('');
    controller.images = <File>[].obs; // Initialize as an empty RxList<File>
    coverImagePicked = false;
    controller.title.value = '';
    controller.description.value = '';
    controller.location.value = '';
    controller.categoryId.value = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async {
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
        return true;
      },
    child:  StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          print('snapshot data ${snapshot.data}');
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          : 
    Scaffold(
      appBar: AppBar(
        title: Text('انشئ خدمتك'),
        leading: Container(),
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسم الخدمه',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        onChanged: (value) => controller.title.value = value,
                        decoration: InputDecoration(
                          hintText: 'أدخل اسم الخدمه',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 18.0),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وصف',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        onChanged: (value) =>
                            controller.description.value = value,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'ادخل وصف ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 18.0),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'القسم',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => DropdownButtonFormField(
                          value: controller.categoryId.value.isNotEmpty
                              ? controller.categoryId.value
                              : null,
                          items: controller.categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category['id'],
                                  child: Text(category['name']),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.categoryId.value = value.toString();
                            categoryController.text = value.toString();
                            controller.update();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 18.0),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الموقع',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: locationController,
                        onChanged: (value) => controller.location.value = value,
                        decoration: InputDecoration(
                          hintText: 'ادخل موقعك',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 18.0),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await controller.pickCoverImage();
                  setState(() {
                    coverImagePicked = true;
                  });
                },
                child: Text(
                  ' اختار صورة غلاف خدمتك',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF7210ff)),
                  elevation: MaterialStateProperty.all<double>(5.0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (coverImagePicked && controller.coverImage.path.isNotEmpty)
                Image.file(
                  controller.coverImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await controller.pickImages();
                  setState(() {});
                },
                child: Text(
                  ' اختار صور خدمتك',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF7210ff)),
                  elevation: MaterialStateProperty.all<double>(5.0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (controller.images != null && controller.images!.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.images!.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      controller.images![index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          bool isValid = true;

                          if (titleController.text.isEmpty) {
                            controller.showSnackbar('يرجى تعبئة اسم الخدمه.');
                            isValid = false;
                          }
                         else if (descriptionController.text.isEmpty) {
                            controller.showSnackbar('يرجى تعبئة وصف الخدمه.');
                            isValid = false;
                          } 
                          else if (locationController.text.isEmpty) {
                            controller.showSnackbar('يرجى تعبئة موقع الخدمه.');
                            isValid = false;
                          }
                         else if (categoryController.text.isEmpty) {
                            controller.showSnackbar('يرجى اختيار قسم.');
                            isValid = false;
                          }
                         else if (controller.coverImage.path.isEmpty) {
                            controller.showSnackbar('يرجى اختيار صورة غلاف.');
                            isValid = false;
                          }
                         else if (controller.images == null ||
                              controller.images!.isEmpty) {
                            controller.showSnackbar('يرجى اختيار صور خدمتك.');
                            isValid = false;
                          }
                         else if (descriptionController.text.length < 25) {
                            controller.showSnackbar(
                                'الوصف يجب أن يكون أكثر من 25 حرف.');
                            isValid = false;
                          }
                          if (isValid) {
                            setState(() {
                              isLoading = true;
                            });

                            await controller.createService();

                            setState(() {
                              isLoading = false;
                            });
                            clearForm();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            Text("جاري الانشاء")
                          ],
                        )
                      : Text(
                          'انشئ خدمتك !',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
         }) );}
}
