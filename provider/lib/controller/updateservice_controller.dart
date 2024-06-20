import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/models/service_model.dart';
import 'package:worker/services/api/service_api.dart';

class UpdateServiceController extends GetxController {
  final ServiceApi _serviceApi = ServiceApi();
 var isLoading = false.obs;
   var title = ''.obs;
  var description = ''.obs;
  var price = 0.obs;
  var location = ''.obs;
  var categoryId = ''.obs;
  final coverImage = (null as File?).obs;
  var images = <File>[].obs;

  final categories = [
  {"id": "66127b95d37e2318a184cdcd", "name": "طلاء الحوائط"},
  {"id": "66127a89d37e2318a184cdc2", "name": "كوافير رجالي"},
  {"id": "66127a67d37e2318a184cdbe", "name": "الأجهزه الالكترونيه"},
  {"id": "66127a12d37e2318a184cdba", "name": "تصليح التكيفات"},
  {"id": "661279f1d37e2318a184cdb6", "name": "خدمات النقل "},
  {"id": "661279bfd37e2318a184cdb2", "name": "غسيل الملابس"},
  {"id": "6612799cd37e2318a184cdae", "name": "الأجهزه الكهربائيه"},
  {"id": "6612796ed37e2318a184cdaa", "name": "خدمات التنظيف"},
  {"id": "66127936d37e2318a184cda6", "name": "كوافير نسائي"},
  {"id": "66127912d37e2318a184cda2", "name": "اصلاح السيارات"},
  {"id": "661278dad37e2318a184cd9e", "name": "تأجير السيارات"},
  {"id": "661278a7d37e2318a184cd9a", "name": "السباكه"}
];


  void updateTitle(String value) => title.value = value;
  void updateDescription(String value) => description.value = value;
 // void updatePrice(int value) => price.value = value;
  void updateLocation(String value) => location.value = value;
  void updateCategoryId(String value) => categoryId.value = value;
  void updateCoverImage(File value) => coverImage.value = value;
  void updateImages(List<File> value) => images.assignAll(value);

  Future<void> updateService(String id) async {
    try {
      final response = await _serviceApi.updateService(
        id: id,
        title: title.value,
        description: description.value,
        categoryId: categoryId.value,
      //  price: price.value == 0 ? null : price.value,        
        location: location.value,
        coverImage: coverImage.value,
        images: images.isEmpty ? null : images.toList(),
      );

      if (response.statusCode == 200) {
        // Handle success
        Get.snackbar('تهانينا', 'تم تحديث الخدمه بنجاح');
      } else {
        // Handle error
        Get.snackbar('عذرا', 'حاول في وقتا لاحق');
      }
    } catch (e) {
      Get.snackbar('عذرا', 'حاول في وقتا لاحق');
    }
  }

   Future<void> deleteService(String id) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذه الخدمة؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('حذف'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final response = await _serviceApi.deleteService(id: id);

        if (response.statusCode == 200) {
          // Handle success
          Get.snackbar('تم', '  تم حذف الخدمه بنجاح');
        } else {
          // Handle error
          Get.snackbar('عذرا', '   حاول في وقتا لاحق');
        }
      }
    } catch (e) {
      Get.snackbar('عذرا ', ' حاول في وقتا لاحق  ');
    }
  }
}
