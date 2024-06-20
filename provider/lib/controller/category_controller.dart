import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:worker/models/category_model.dart';
import 'package:worker/services/api/category_api.dart';

class CategoryController extends GetxController{
  final categoryApi = CategoryApi();
  var categories = Category(id: "", name: "", image: "", options: []);
  



}