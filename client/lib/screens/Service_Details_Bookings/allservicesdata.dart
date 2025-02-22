import 'package:clientphase/screens/Service_Details_Bookings/Shipping.dart';
import 'package:flutter/material.dart';
import 'package:clientphase/controllers/home_catigory_controller.dart';
import 'package:clientphase/models/home_category_model.dart';
import 'package:clientphase/categories/ItemOfService/ServiceItem.dart';
import 'package:get/get.dart';

class AllServicesData extends StatefulWidget {
  @override
  _AllServicesDataState createState() => _AllServicesDataState();
}

class _AllServicesDataState extends State<AllServicesData> {
  final CategoryController _categoryController = CategoryController();
  late Future<List<HomeCategoryModel>> _categoryFuture;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchCategories();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final future = _categoryController.fetchCategories();
    if (_isMounted) {
      setState(() {
        _categoryFuture = future;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchCategories,
      child: FutureBuilder<List<HomeCategoryModel>>(
        future: _categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<HomeCategoryModel> categories = snapshot.data!;
            List<HomeCategoryModel> firstRowCategories = categories.length >= 4
                ? categories.sublist(0, 4)
                : categories;
            List<HomeCategoryModel> secondRowCategories = categories.length > 4
                ? (categories.length >= 8 ? categories.sublist(4, 8) : categories.sublist(4, categories.length))
                : [];
            List<HomeCategoryModel> thirdRowCategories = categories.length > 8
                ? (categories.length >= 12 ? categories.sublist(8, 12) : categories.sublist(8, categories.length))
                : [];

            return Column(
              children: [
                // First Row
                SizedBox(height: 30,),
                if (firstRowCategories.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: firstRowCategories.map((category) {
                      return Expanded(
                        child: ItemService(
                          category.imageUrl,
                          category.name,
                          onTap: () {
                            Get.to(ShippingService(
                              id: category.id,
                              nameserv: category.name,
                            ));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                if (secondRowCategories.isNotEmpty) ...[
                  SizedBox(height: 10), // Spacer between rows
                  // Second Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: secondRowCategories.map((category) {
                      return Expanded(
                        child: ItemService(
                          category.imageUrl,
                          category.name,
                          onTap: () {
                            Get.to(ShippingService(
                              id: category.id,
                              nameserv: category.name,
                            ));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (thirdRowCategories.isNotEmpty) ...[
                  SizedBox(height: 10), // Spacer between rows
                  // Third Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: thirdRowCategories.map((category) {
                      return Expanded(
                        child: ItemService(
                          category.imageUrl,
                          category.name,
                          onTap: () {
                            Get.to(ShippingService(
                              id: category.id,
                              nameserv: category.name,
                            ));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            );
          } else {
            return Center(child: Text('خطأ في التحميل'));
          }
        },
      ),
    );
  }
}
