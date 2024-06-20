import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:worker/controller/getmyservice_controller.dart';
import 'package:worker/models/service_model.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/service_screens/updateservice_screen.dart';

class MyServiceScreen extends StatefulWidget {
  @override
  _MyServiceScreenState createState() => _MyServiceScreenState();
}

class _MyServiceScreenState extends State<MyServiceScreen> {
  final MyServiceController _controller = Get.put(MyServiceController());

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
    Get.delete<MyServiceController>();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    await _controller.fetchServiceTitles();
  }

 @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          print('snapshot data ${snapshot.data}');
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          : 
    Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
      
          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildProfileView();
          }
        
      }),
    );
  });}
  Widget _buildProfileView() {
    return WillPopScope(
     onWillPop: () async {
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
        return true;
      },
    child:  
     Scaffold(
      appBar: AppBar(
        title: Text('خدماتي '),
        leading: Container(),
        // backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Set app bar foreground color
      ),
      body: Center(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return CircularProgressIndicator(
              color: Color(0xFF7210ff), // Set loading indicator color
            );
          } else if (_controller.serviceTitles.isEmpty) {
            return Center(
              child: Text(
                "قم بانشاء خدماتك",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _controller.fetchServiceTitles(),
              color: Color(0xFF7210ff), // Set refresh indicator color
              child: ListView.builder(
                itemCount: _controller.serviceTitles.length,
                itemBuilder: (context, index) {
                  final service = _controller.serviceTitles[index];
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      title: ListTile(
                        title: Text(
                          service.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7210ff),
                          ),
                        ),
                        subtitle: Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => _onServiceTap(service),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF7210ff),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ),
    ));
         }

  void _onServiceTap(Service service) {
    Get.to(() => UpdateServiceScreen(service: service));
  }
}
