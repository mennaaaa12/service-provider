import 'package:get/get.dart';
import 'package:worker/services/api/profile_api.dart';
import 'package:worker/models/user_model.dart';

class BalanceController extends GetxController {
  final profileApi = ProfileApi();
  var balance = 0.0.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    try {
      isLoading(true);
      final response = await profileApi.getMe();
      balance.value = (response.data['data']['providerAccount']['balance'] as num).toDouble();
    } catch (e) {
      error.value = 'Failed to fetch balance';
    } finally {
      isLoading(false);
      update();
    }
  }
}