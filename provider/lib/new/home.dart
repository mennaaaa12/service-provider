import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:worker/chat/inbox.dart';
import 'package:worker/controller/getmyservice_controller.dart';
import 'package:worker/new/profiletab/editprofile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:worker/view/booking_screens/mybooking_screen.dart';
import 'package:worker/view/newbooking/ui/masterbooking.dart';
import 'package:worker/view/service_screens/create_service_screen.dart';
import 'package:worker/view/service_screens/myservices.dart';
import 'package:worker/view/service_screens/updateservice_screen.dart';
import 'package:worker/models/service_model.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final MyServiceController _controller = Get.put(MyServiceController());
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MyServiceScreen(),
    BookingOptionScreen(),
    CreateServiceScreen(),
    Inbox(),
    editprof(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF7210ff),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'خدماتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'حجوزات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'انشاء خدمة ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: ' المحادثة ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ملف شخصي',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
