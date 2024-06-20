// controller/provider_booking_controller.dart
import 'package:get/get.dart';
import 'package:worker/models/booking_model.dart';
import 'package:worker/services/api/booking_api.dart';
import 'package:worker/services/api/transaction_api.dart';

class ProviderBookingController extends GetxController {
  var isLoading = true.obs;
  var providerBookings = <Booking>[].obs;
  var acceptedBookings = <Booking>[].obs;
  var showCashPaymentButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProviderBookings();
  }

  Future<void> fetchProviderBookings() async {
    try {
      isLoading(true);

      final response = await BookingApi().getProviderBooking();

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData["data"]["docs"] is List) {
          final bookings = responseData["data"]["docs"] as List<dynamic>;
          providerBookings.assignAll(
              bookings.map((data) => Booking.fromJson(data)).toList());

          acceptedBookings.assignAll(providerBookings
              .where((booking) => booking.status == 'accepted')
              .toList());
        } else {
          print('Unexpected response format: $responseData');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching provider bookings: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptBooking(String bookingId) async {
    try {
      await BookingApi().sendBookingResponse(
        bookingId: bookingId,
        response: true,
      );
      fetchProviderBookings();
      showCashPaymentButton.value = true;
    } catch (e) {
      print('Error accepting booking: $e');
    }
  }

  Future<void> rejectBooking(String bookingId, String reason) async {
    try {
      await BookingApi().sendBookingResponse(
        bookingId: bookingId,
        response: false,
        rejectReason: reason,
      );
      fetchProviderBookings();
    } catch (e) {
      print('Error rejecting booking: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await BookingApi().cancleBooking(bookingId: bookingId);
      fetchProviderBookings();
    } catch (e) {
      print('Error cancelling booking: $e');
    }
  }

  // controller/provider_booking_controller.dart
  Future<void> cashPayment(String bookingId) async {
    try {
      await TransactionApi().cashPayment(bookingId: bookingId);
      providerBookings.removeWhere((booking) => booking.id == bookingId);
      showCashPaymentButton.value = false;
    } catch (e) {
      print('Error processing cash payment: $e');
    }
  }
}
