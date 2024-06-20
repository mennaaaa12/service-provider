import 'package:get/get.dart';
import 'package:worker/models/service_model.dart';
import 'package:worker/models/review_model.dart'; // Import the Review model
import 'package:worker/services/api/service_api.dart';
import 'package:worker/services/api/review_api.dart'; // Import the ReviewApi

class MyServiceController extends GetxController {
  var isLoading = true.obs;
  var serviceTitles = <Service>[].obs;
  var hasConnection = true.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchServiceTitles();
  }

  Future<void> fetchServiceTitles() async {
    try {
      isLoading(true);
  hasConnection(true);

      final response = await ServiceApi().getmyService();

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData["data"]["docs"] is List) {
          final services = responseData["data"]["docs"] as List<dynamic>;
          serviceTitles.assignAll(
              services.map((data) => Service.fromJson(data)).toList());

          // Fetch and assign average rating for each service
          await fetchAverageRatingsForServices();
        } else {
          print('Unexpected response format: $responseData');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching service titles: $e');
        hasConnection(false);

    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAverageRatingsForServices() async {
    try {
      for (var service in serviceTitles) {
        // Fetch average rating for each service
        final reviews = await ReviewApi().getServiceReview(service.id);
        if (reviews.isNotEmpty) {
          // Calculate average rating
          final totalRatings = reviews.fold(
    0.0, (previousValue, review) => previousValue + review.ratings);

          service.ratingsAverage = totalRatings / reviews.length;
        } else {
          service.ratingsAverage = 0.0; // No reviews yet
        }
      }
    } catch (e) {
      print('Error fetching average ratings: $e');
    }
  }
}
