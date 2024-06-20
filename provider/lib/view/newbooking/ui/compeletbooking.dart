import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/newbooking/bookingcontroller/compeletcontroller.dart';

class CompeletTpa extends StatefulWidget {
  @override
  _CompeletTpaState createState() => _CompeletTpaState();
}

class _CompeletTpaState extends State<CompeletTpa> {
  final CompeletBookingController _bookingController =
      Get.put(CompeletBookingController());
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
    Get.delete<CompeletBookingController>();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    await _bookingController.fetchPendingBookings();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
      
          if (_bookingController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildProfileView();
          }
        
      }),
    );
  }

  Widget _buildProfileView() {
    return Scaffold(
      body: Obx(() {
        if (_bookingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_bookingController.myBookings.isEmpty) {
          return Center(
            child: Text(
              'لا توجد حجوزات مكتملة.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => _bookingController.fetchPendingBookings(),
            color: Color(0xFF7210ff),
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
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 43, 114, 28)
                                  .withOpacity(0.5),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'الوصف: ${booking.description}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'تاريخ بداية الخدمة: ${booking.formatDate(booking.startDate)}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'تاريخ نهاية الخدمة: ${booking.formatDate(booking.endDate)}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'السعر: ${booking.price}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
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
                            SizedBox(height: 8),
                            if (booking.rejectReason != null) ...[
                              SizedBox(height: 8),
                              Text(
                                'سبب الرفض: ${booking.rejectReason}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
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
      }),
      backgroundColor: Colors.white,
    );
  }
}
