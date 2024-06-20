import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/chat/chat_screen.dart';
import 'package:worker/chat/chatcontroller.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/newbooking/bookingcontroller/pendingcontroller.dart'; // Import your Booking model

class PendingBookingTap extends StatefulWidget {
  @override
  _PendingBookingTapState createState() => _PendingBookingTapState();
}

class _PendingBookingTapState extends State<PendingBookingTap> {
  final PendingBookingController _bookingController = Get.put(PendingBookingController());
          ChatController serviceController = Get.put(ChatController());

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
    Get.delete<PendingBookingController>();
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
              'لا توجد حجوزات معلقة.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => _bookingController.fetchPendingBookings(), // Refresh when pulled down
            child: ListView.builder(
              itemCount: _bookingController.myBookings.length,
              itemBuilder: (context, index) {
                var booking = _bookingController.myBookings[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
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
                            Text(
                              'الوصف: ${booking.description}',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'تاريخ بداية الخدمة: ${booking.formatDate(booking.startDate)}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'تاريخ نهاية الخدمة: ${booking.formatDate(booking.endDate)}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'السعر: ${booking.price}',
                              style: TextStyle(fontSize: 14, color: Colors.black),
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
                            if (booking.rejectReason != null) ...[
                              SizedBox(height: 8),
                              Text(
                                'سبب الرفض: ${booking.rejectReason}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ],
                        ),
                      ),
                    
                      SizedBox(height: 8),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _acceptBooking(booking.id);
                              },
                              child: Text(
                                'موافقة',
                                style: TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _showRejectionDialog(context, booking.id);
                              },
                              child: Text(
                                'رفض',
                                style: TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                              ),
                            ),
                             SizedBox(width: 8),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF7210ff),
                              ),
                              child: IconButton(
                                  onPressed: () {
                              Get.to(ChatScreen(
                                receiverId: booking.user.id,username:booking.user.name ,
                              ));
                              serviceController
                                  .createNewUserChat(booking.user.id);
                            },
                                  icon: Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }),
      backgroundColor: Colors.white, // Set Scaffold background color to white
    );
  }

  void _acceptBooking(String bookingId) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد القبول'),
          content: Text('هل أنت متأكد أنك تريد قبول هذا الحجز؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('لا'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _bookingController.acceptBooking(bookingId); // Accept the booking
              },
              child: Text('نعم'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectionDialog(BuildContext context, String bookingId) {
    String rejectReason = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تأكيد الرفض'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('هل أنت متأكد أنك تريد رفض هذا الحجز؟'),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'سبب الرفض',
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
              child: Text('لا'),
            ),
            ElevatedButton(
              onPressed: () {
                _bookingController.rejectBooking(bookingId, rejectReason);
                Navigator.of(context).pop();
              },
              child: Text('نعم'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
