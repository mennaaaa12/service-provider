import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker/controller/getmyservice_controller.dart';
import 'package:worker/controller/reviewcontroller.dart';
import 'package:worker/new/profiletab/editprofile.dart';
import 'package:worker/new/profiletab/load.dart';

class Raitt extends StatefulWidget {
  @override
  _RaittState createState() => _RaittState();
}

class _RaittState extends State<Raitt> {
  final MyServiceController _controller = Get.put(MyServiceController());
  //final ReviewController _reviewController = Get.put(ReviewController());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchBookings();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    try {
      await _controller.fetchServiceTitles();
    } catch (e) {
      print('Error fetching service titles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التقييمات'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Get.to(editprof());
            },
          ),
        ],
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return CircularProgressIndicator(color: Color(0xFF7210ff));
          } else if (_controller.serviceTitles.isEmpty) {
            return Center(
              child: Text("لا يوجد", style: TextStyle(fontSize: 18)),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _fetchBookings,
              color: Color(0xFF7210ff),
              child: ListView.builder(
                itemCount: _controller.serviceTitles.length,
                itemBuilder: (context, index) {
                  final service = _controller.serviceTitles[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        service.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7210ff),
                        ),
                      ),
                      subtitle: Text(
                        "متوسط ​​التقييمات: ${service.ratingsAverage?.toStringAsFixed(1) ?? '0'}",
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
