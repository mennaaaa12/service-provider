import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worker/chat/chat_api.dart';
import 'package:worker/chat/chat_service.dart';
import 'package:worker/models/user_model.dart';
import 'package:worker/services/api/profile_api.dart';
import 'package:worker/chat/user_chat.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  var isLoading = true.obs;
  var serviceList = <UserChat>[].obs;
var errorMessage = ''.obs;
  @override
  void onInit() {
    getAllUserChats(); // Call fetchServicesByCategory on initialization
    super.onInit();
  }

   Future<List<UserChat>> getAllUserChats() async {
  try {
    isLoading(true);
    final response = await ChatApi().getAllUserChats();
    errorMessage('');

    if (response.statusCode == 200) {
      // Handle successful response
      if (response.data['data'] != null && response.data['data'] is List) {
        final List<UserChat> userChats = (response.data['data'] as List)
            .map((service) => UserChat.fromJson(service))
            .toList();
        serviceList.assignAll(userChats);
        return userChats;
      } else {
        // Handle the case where data is null or not a List
        print('Unexpected data format: ${response.data['data']}');
        return [];
      }
    } else {
      errorMessage('اتصل بالانترنت'); // Set error message here
      return []; // Return an empty list in case of failure
    }
  } catch (e) {
    print('Error fetching service data: $e');
    errorMessage('اتصل بالانترنت');
    return []; // Return an empty list in case of exception
  } finally {
    isLoading(false);
  }
}

  
  Future<void> createNewUserChat(String receiverId) async {
    try {
      await ChatApi().createNewUserChat(receiverId);
      // Optionally, you can perform additional actions after creating the new user chat
    } catch (e) {
      print('Failed to create new user chat: $e');
      rethrow;
    }
  }
}
