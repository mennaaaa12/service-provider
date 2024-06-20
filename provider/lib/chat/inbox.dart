import 'dart:io';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:worker/chat/chantcontainer.dart';
import 'package:worker/chat/chat_screen.dart';
import 'package:worker/chat/chatcontroller.dart';
import 'package:worker/chat/user_chat.dart';
import 'package:worker/new/home.dart';
import 'package:worker/noconnection.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final ChatController serviceController = Get.put(ChatController());
  late List<UserChat> _services = [];
  late List<UserChat> _filteredServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final services = await serviceController.getAllUserChats();
    setState(() {
      _services = services;
      _filteredServices = _services;
      _isLoading = false;
    });
  }

  void _filterServices(String keyword) {
    setState(() {
      _filteredServices = _services
          .where((service) =>
              service.name.toLowerCase().contains(keyword.toLowerCase()) ||
              service.email.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchServices();
  }

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
      child: Obx(() {
        if (serviceController.isLoading.value) {
          return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          print('snapshot data ${snapshot.data}');
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          :  Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('المحاداثات'),
            leading: Container(),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'ابحث',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xFF7210ff)),
                          ),
                          cursorColor: Color(0xFF7210ff),
                          style: TextStyle(fontSize: 10),
                          onChanged: _filterServices,
                        ),
                      ),
                      Expanded(
                        child: _filteredServices.isEmpty
                            ? Center(
                                child: Text(
                                  " لا يوجد محادثات ",
                                  style: TextStyle(fontSize: 24),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _filteredServices.length,
                                itemBuilder: (context, index) {
                                  final service = _filteredServices[index];
                                  return chatContainer(
                                    service: service,
                                    onTap: () {
                                      Get.to(ChatScreen(
                                        receiverId: service.id,
                                        userchat: service,
                                      ));
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
