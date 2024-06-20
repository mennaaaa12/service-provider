import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:worker/network/local/cach_helper.dart';

class HttpServiceLogin {
  static const String baseUrl = 'https://homo.onrender.com/api';

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<void> loginUser(String email, String password) async {
    print(email);
    print(password);
    try {
      final response = await _dio.post(
        '/v1/auth/login',
        data: {'email': email, 'password': password},
      );
      print(response);
      if (response.statusCode == 200) {
        // Login successful
        try {
          print(response.data['data']['token']);
          await CacheHelper.init(); // Ensure initialization before saving token
          await CacheHelper.saveData(
              key: 'token', value: response.data['data']['token']);
          print('Token saved successfully');
        } catch (e) {
          print('Error when saving token: $e');
        }
        return;
      } else {
        // Registration failed
        throw ();
//'Login failed: ${response.data}'
      }
    } catch (e) {
      // Handle network or other errors
      throw ();
      //'Error during Login: $e'
    }
  }
}
