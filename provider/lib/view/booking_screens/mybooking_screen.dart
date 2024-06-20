// views/provider_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/controller/ProviderBookingController.dart';
import 'package:worker/models/booking_model.dart';
import 'package:worker/view/booking_screens/history_of_boking.dart';
import 'package:worker/view/newbooking/ui/masterbooking.dart';

class ProviderBookingScreen extends StatelessWidget {
  final ProviderBookingController _controller =
      Get.put(ProviderBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(BookingOptionScreen());
            },
            icon: Icon(Icons.history_sharp),
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return CircularProgressIndicator();
          } else {
            return RefreshIndicator(
              onRefresh: () => _controller.fetchProviderBookings(),
              child: ListView.builder(
                itemCount: _controller.providerBookings.length,
                itemBuilder: (context, index) {
                  final booking = _controller.providerBookings[index];
                  final user = booking.user.name;
                  final isAccepted =
                      _controller.acceptedBookings.contains(booking);

                  if (booking.status != 'canceled' &&
                      booking.status != 'rejected') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User: $user',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Description: ${booking.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!isAccepted)
                                    ElevatedButton(
                                      onPressed: () {
                                        _controller.acceptBooking(booking.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text('Accept'),
                                    ),
                                  if (!isAccepted)
                                    ElevatedButton(
                                      onPressed: () {
                                        _showRejectionDialog(
                                            context, booking.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Text('Reject'),
                                    ),
                                  if (_controller.showCashPaymentButton.value)
                                    ElevatedButton(
                                      onPressed: () {
                                        _showCashPaymentConfirmationDialog(
                                            context, booking.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Text('Cash Payment'),
                                    ),
                                  if (isAccepted)
                                    ElevatedButton(
                                      onPressed: () {
                                        _showCancellationConfirmationDialog(
                                            context, booking.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      child: Text('Cancel'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }
        }),
      ),
    );
  }

  void _showRejectionDialog(BuildContext context, String bookingId) {
    String rejectReason = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Rejection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to reject this booking?'),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Reason for rejection',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  rejectReason = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.rejectBooking(bookingId, rejectReason);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCashPaymentConfirmationDialog(
      BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Cash Payment'),
          content: Text('Are you sure you want to proceed with cash payment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.cashPayment(bookingId);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancellationConfirmationDialog(
      BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.cancelBooking(bookingId);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }
}
