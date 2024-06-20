import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/newbooking/bookingcontroller/cancelcontroller.dart';

class CancelTab extends StatefulWidget {
  @override
  _CancelTabState createState() => _CancelTabState();
}

class _CancelTabState extends State<CancelTab> {
  final CancelBookingController _bookingController = Get.put(CancelBookingController());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    // Set up timer for automatic refresh
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchBookings();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    Get.delete<CancelBookingController>();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    await _bookingController.fetchPendingBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
    
      if (_bookingController.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
        
      } else if (_bookingController.myBookings.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text(
              'لا توجد حجوزات ملغاة.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
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
    return RefreshIndicator(
      onRefresh: () =>
          _bookingController.fetchPendingBookings(), // Refresh when pulled down
      color: Color(0xFF7210ff), // Set refresh indicator color
      child: ListView.builder(
        itemCount: _bookingController.myBookings.length,
        itemBuilder: (context, index) {
          var booking = _bookingController.myBookings[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                   width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 242, 110, 100)
                            .withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الاسم: ${booking.user.name}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text('الوصف: ${booking.description}',
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text(
                          'تاريخ بداية الخدمة: ${booking.formatDate(booking.startDate)}',
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 8),
                      Text(
                        'تاريخ نهاية الخدمة: ${booking.formatDate(booking.endDate)}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text('السعر: ${booking.price}',
                          style: TextStyle(fontSize: 14)),
                       SizedBox(height: 8),
                            Text(
                              'العنوان: ${booking.address.city}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'الكود البريدي:  ${booking.address.postalCode}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                             Text('رقم الهاتف: ${booking.address.phone}',
                          style: TextStyle(fontSize: 14)),
                      if (booking.rejectReason != null) ...[
                        SizedBox(height: 8),
                        Text('سبب الرفض: ${booking.rejectReason}',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
