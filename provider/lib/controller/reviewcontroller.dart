// //CONTROLLER

// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:worker/models/review_model.dart';
// import 'package:worker/services/api/review_api.dart';

// class ReviewController extends GetxController {
//   final ReviewApi reviewApi = ReviewApi();

//   final serviceId = ''.obs;
//   final ratings = ''.obs;
//   var isLoading = true.obs;
//   var reviewList = <Review>[].obs;
//   final title = ''.obs;
//   final averageRating = 0.0.obs;
//   final totalRatings = 0.obs;


//   @override
//   void onInit() {
//     super.onInit();
//       print('Average Rating: ${averageRating.value}');

//     // Fetch reviews when the controller is initialized
//     fetchReview(serviceId.value);
//   }

//   // Fetch reviews for a given service ID
//   Future<void> fetchReview(String serviceId) async {
//     try {
//       isLoading(true);
//       final response = await reviewApi.getServiceReview(serviceId);
//       reviewList.assignAll(response);
//       // Calculate ratings after fetching reviews
//       calculateRatings();
//     } catch (e) {
//       print('Error fetching review data: $e');
//     } finally {
//       isLoading(false);
//       update(); // Update the controller
//     }
//   }

//  void calculateRatings() {
//   double total = 0;
//   int reviewCount = reviewList.length; // Get the number of reviews
//   reviewList.forEach((review) {
//     total += review.ratings;
//   });
//   // Calculate average rating only if there are reviews
//   averageRating.value = reviewCount > 0 ? total / reviewCount : 0;
//   // Debug: Print calculated average rating
//   print('Average Rating: ${averageRating.value}');
// }

   
// }