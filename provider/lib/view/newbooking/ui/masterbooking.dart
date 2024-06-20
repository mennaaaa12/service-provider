import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/newbooking/ui/acceptbooking.dart';
import 'package:worker/view/newbooking/ui/cancelbooking.dart';
import 'package:worker/view/newbooking/ui/compeletbooking.dart';
import 'package:worker/view/newbooking/ui/payement.dart';
import 'package:worker/view/newbooking/ui/pendingbooking.dart';

class BookingOptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
    onWillPop: () async {
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
        return true;
      },
    child: DefaultTabController(
      length: 4,
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          print('snapshot data ${snapshot.data}');
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          : 
       Scaffold(
        appBar: AppBar(
          title: Text(
            'تفاصيل الحجوزات',
            style: TextStyle(),
          ),
          leading: Container(),
          bottom: TabBar(
            tabs: [
              Tab(text: 'مؤكد'),
              Tab(text: 'مكتمل'),
              Tab(text: 'ملغى'),
              Tab(text: 'معلق'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AcceptBookingTap(),
            CompeletTpa(),
            CancelTab(),
            PendingBookingTap(), //PaymentBookingScreen(),
          ],
        ),
      );
   }) ));
  }
}
