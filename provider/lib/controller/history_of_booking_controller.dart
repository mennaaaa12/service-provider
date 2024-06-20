import 'package:dio/dio.dart';
import 'package:worker/models/booking_model.dart';
import 'package:worker/services/api/booking_api.dart';

class HistoryBookingController {
  final BookingApi _bookinghistoriApi = BookingApi();

  Future<List<Booking>> getBookingsByStatus(String status) async {
    try {
      final Response<dynamic> response =
          await _bookinghistoriApi.getProviderBookingstatusprovider(status);
      print('Response Data: ${response.data}');

      final List<Booking> bookings = Booking.parseBookings(response.data);
      return bookings;
    } catch (e) {
      print(e);
      throw Exception('Failed to get bookings: $e');
    }
  }
}
