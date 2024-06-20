import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worker/services/api/service_api.dart';

class CreateServiceController extends GetxController {
  final ServiceApi _serviceApi = ServiceApi();

  final title = ''.obs;
  final description = ''.obs;
  final categoryId = ''.obs;
  // final price = 0.obs;
  final priceAfterDiscount = 0.obs;
  late File coverImage = File(''); // Initialize coverImage to an empty File
  RxList<File>? images = RxList<File>();
  final location = ''.obs; // Added location property

  // Manually defined list of categories
  final List<Map<String, dynamic>> categories = [
    {"id": "66127b95d37e2318a184cdcd", "name": " طلاء الحوائط"},
    {"id": "66127a89d37e2318a184cdc2", "name": " كوافير رجالي"},
    {"id": "66127a67d37e2318a184cdbe", "name": "الأجهزه الالكترونيه"},
    {"id": "66127a12d37e2318a184cdba", "name": " تصليح التكيفات"},
    {"id": "661279f1d37e2318a184cdb6", "name": "خدمات النقل "},
    {"id": "661279bfd37e2318a184cdb2", "name": "  غسيل الملابس"},
    {"id": "6612799cd37e2318a184cdae", "name": "الأجهزه الكهربائيه"},
    {"id": "6612796ed37e2318a184cdaa", "name": " خدمات التنظيف"},
    {"id": "66127936d37e2318a184cda6", "name": " كوافير نسائي"},
    {"id": "66127912d37e2318a184cda2", "name": " اصلاح السيارات"},
    {"id": "661278dad37e2318a184cd9e", "name": "تأجير السيارات"},
    {
      "id": "661278a7d37e2318a184cd9a",
      "name": " السباكه"
    }, // Add more categories as needed
  ];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> createService() async {
    try {
      if (description.value.length < 25) {
        Get.snackbar(
          'تنبيه',
          'الوصف يجب أن يكون أكثر من 25 حرف',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return; // Stop further execution if description is too short
      }

      await _serviceApi.createService(
        title: title.value,
        description: description.value,
        categoryId: categoryId.value,
        // price: price.value,
        coverImage: coverImage,
        images: images?.toList(),
        location: location.value, // Pass location to createService
      );
      Get.snackbar(
        'تهانينا',
        '  تم انشاء الخدمه بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Clear input fields after creating a service
      clearFields();

      // Service created successfully, perform any necessary actions
    } catch (e) {
      showSnackbar(' عذرا حاول في وقتا ');
    }
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'عذرا',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void clearFields() {
    title.value = '';
    description.value = '';
    categoryId.value = '';
    // price.value = 0;
    // Check if coverImage is not null before clearing
    if (coverImage.existsSync()) {
      coverImage.deleteSync(); // Delete the cover image file if it exists
    }
    coverImage = File(''); // Reset cover image
    images?.clear(); // Clear images list
    location.value = ''; // Clear location field
  }

  Future<void> pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      images?.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    }
  }
}
