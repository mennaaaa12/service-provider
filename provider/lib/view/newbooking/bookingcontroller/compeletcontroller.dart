import 'package:get/get.dart';
import 'package:worker/models/booking_model.dart';
import 'package:worker/services/api/booking_api.dart';
import 'package:worker/services/api/transaction_api.dart';

class CompeletBookingController extends GetxController {
  var isLoading = true.obs;
  var myBookings = <Booking>[].obs;
 var hasConnection = true.obs; 
  @override
  void onInit() {
    super.onInit();
    fetchPendingBookings();
  }

  Future<void> fetchPendingBookings() async {
    try {
      isLoading(true);
 hasConnection(true);
      final response =
          await BookingApi().getProviderBookingstatusprovider('completed');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData["data"]["docs"] is List) {
          final bookings = responseData["data"]["docs"] as List<dynamic>;
          myBookings.assignAll(
              bookings.map((data) => Booking.fromJson(data)).toList());
        } else {
          print('Unexpected response format: $responseData');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pending bookings: $e');
       hasConnection(false);
    } finally {
      isLoading(false);
    }
  }
}
