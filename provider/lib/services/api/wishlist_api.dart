import 'package:dio/dio.dart';
import 'package:worker/services/api/api.dart';

class WishlistApi {
  final Dio _dio = DioClient().dio;

  Future<Response> addServiceToWishlist({required String serviceId}) async {
    Map<String, dynamic> data = {
      'serviceId': serviceId,
    };

    try {
      return await _dio.post("/v1/wishlist", data: data);
    } catch (e) {
      throw Exception("Failed to add service to wishlist | error: $e");
    }
  }

  Future<Response> getMyWishlist() async {
    try {
      return await _dio.get('/v1/wishlist');
    } catch (e) {
      throw Exception("Failed to fetch wishlist | error: $e");
    }
  }

  Future<Response> removeServiceFromWishlist(
      {required String serviceId}) async {
    try {
      return await _dio.delete("/v1/wishlist", data: {"serviceId": serviceId});
    } catch (e) {
      throw Exception("Failed to remove service from wishlist | error: $e");
    }
  }
}
