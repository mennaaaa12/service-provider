import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worker/controller/updateservice_controller.dart';
import 'package:worker/models/service_model.dart';
import 'package:worker/noconnection.dart';

class UpdateServiceScreen extends StatefulWidget {
  final Service service;

  UpdateServiceScreen({required this.service});

  @override
  State<UpdateServiceScreen> createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends State<UpdateServiceScreen> {
  final UpdateServiceController _controller =
      Get.put(UpdateServiceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildProfileView(),
        );
      }
    });
  }

  Widget _buildProfileView() {
    return  StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          print('snapshot data ${snapshot.data}');
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          : 
    Scaffold(
      appBar: AppBar(
        title: Text('تحديث الخدمة'),
        // backgroundColor: Color(0xFF7210ff),
        //foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.service.title,
                decoration: InputDecoration(
                  labelText: 'عنوان الخدمة',
                  hintText: 'أدخل عنوان الخدمة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF7210ff), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(fontSize: 16.0),
                onChanged: (value) => _controller.updateTitle(value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: widget.service.description,
                maxLines:
                    4, // Adjust this as needed based on the expected length of the description
                decoration: InputDecoration(
                  labelText: 'وصف الخدمة',
                  hintText: 'أدخل وصف الخدمة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF7210ff), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(fontSize: 16.0),
                onChanged: (value) => _controller.updateDescription(value),
              ),
              SizedBox(height: 20.0),
              // TextFormField(
              //   initialValue: service.price.toString(),
              //   decoration: InputDecoration(
              //     labelText: 'السعر',
              //     hintText: 'أدخل السعر',
              //     prefixText: '\ج\ن\ي\ة ', // Add currency symbol if needed
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     filled: true,
              //     fillColor: Colors.grey[200],
              //     contentPadding:
              //         EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide:
              //           BorderSide(color: Color(0xFF7210ff), width: 2.0),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide:
              //           BorderSide(color: Colors.grey[400]!, width: 1.0),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   keyboardType: TextInputType.number,
              //   style: TextStyle(fontSize: 16.0),
              //   onChanged: (value) => _controller.updatePrice(int.parse(value)),
              // ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: widget.service.location,
                decoration: InputDecoration(
                  labelText: 'الموقع',
                  hintText: 'أدخل الموقع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF7210ff), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(fontSize: 16.0),
                onChanged: (value) => _controller.updateLocation(value),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: widget.service.categoryid,
                decoration: InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF7210ff), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: _controller.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id']!,
                    child: Text(
                      category['name']!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _controller.updateCategoryId(value);
                  }
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  File? image = await _getImage();
                  if (image != null) {
                    _controller.updateCoverImage(image);
                  }
                },
                child: Text(
                  'تحديث صورة الغلاف',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
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
              SizedBox(
                height: 30,
              ),
              Obx(() {
                if (_controller.coverImage.value != null) {
                  return Image.file(
                    _controller.coverImage.value!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                } else {
                  return SizedBox
                      .shrink(); // Hide if cover image is not selected
                }
              }),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  List<File>? images = await _getImages();
                  if (images != null) {
                    _controller.updateImages(images);
                  }
                },
                child: Text(
                  'تحديث الصور',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
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
              Obx(() {
                final images = _controller.images;
                if (images.isNotEmpty) {
                  return Column(
                    children: List.generate(
                      images.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            images[index],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink(); // Hide if no images selected
                }
              }),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _controller.isLoading.value = true; // Start loading
                  });

                  await _controller.updateService(widget.service.id);

                  setState(() {
                    _controller.isLoading.value = false; // Stop loading
                  });
                },
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    // If loading, show the circular progress indicator
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'جاري التحديث...',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    );
                  } else {
                    // If not loading, show the regular text
                    return Text(
                      'تحديث الخدمة',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    );
                  }
                }),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
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

              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _controller.deleteService(widget.service.id),
                child: Text(
                  'حذف الخدمة',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
            ],
          ),
        ),
      ),
    );
        });}

  Future<File?> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  Future<List<File>?> _getImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    }
    return null;
  }
}
