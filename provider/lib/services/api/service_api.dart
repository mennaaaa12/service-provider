import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:worker/services/api/api.dart';

class ServiceApi {
  final Dio _dio = DioClient().dio;

  Future<Response> createService(
      {required String title,
      required String description,
      required String categoryId,
      // required int price,
      required File coverImage,
      required String location,
      List<File>? images}) async {
    try {
      final formData = FormData();

      // Add fields to the form data
      formData.fields.addAll([
        MapEntry('title', title),
        MapEntry('description', description),
        MapEntry('category', categoryId),
        // MapEntry('price', price.toString()),
        MapEntry('location', location),
      ]);

      String fileName = coverImage.path.split('/').last;
      var fileExt = fileName.split('.').last;

      // Add cover image to the form data
      formData.files.add(MapEntry(
        'coverImage',
        MultipartFile.fromFileSync(coverImage.path,
            contentType: MediaType("image", fileExt)),
      ));

      // Add images to the form data if available
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          String fileName = images[i].path.split('/').last;
          var fileExt = fileName.split('.').last;

          formData.files.add(MapEntry(
            'images',
            MultipartFile.fromFileSync(images[i].path,
                contentType: MediaType("image", fileExt)),
          ));
        }
      }

      // Make POST request with form data
      return await _dio.post(
        '/v1/service',
        data: formData,
      );
    } catch (e) {
      throw Exception("Failed to create service $e");
    }
  }

  Future<Response> updateService(
      {required String id,
      String? title,
      String? description,
      String? categoryId,
      String? location,
      // int? price,
      File? coverImage,
      List<File>? images}) async {
    final formData = FormData();

    // Add fields to the form data if they exist
    if (title != null && title.isNotEmpty) {
      formData.fields.add(MapEntry('title', title));
    }
    if (description != null && description.isNotEmpty) {
      formData.fields.add(MapEntry('description', description));
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      formData.fields.add(MapEntry('category', categoryId));
    }

    if (location != null && location.isNotEmpty) {
      formData.fields.add(MapEntry('location', location));
    }

    // if (price != null) {
    //   formData.fields.add(MapEntry('price', price.toString()));
    // }

    // Add cover image to the form data if it exists
    if (coverImage != null) {
      String fileName = coverImage.path.split('/').last;
      var fileExt = fileName.split('.').last;

      // Add cover image to the form data
      formData.files.add(MapEntry(
        'coverImage',
        MultipartFile.fromFileSync(coverImage.path,
            contentType: MediaType("image", fileExt)),
      ));
    }

    // Add images to the form data if available
    if (images != null && images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        String fileName = images[i].path.split('/').last;
        var fileExt = fileName.split('.').last;

        formData.files.add(MapEntry(
          'images',
          MultipartFile.fromFileSync(images[i].path,
              contentType: MediaType("image", fileExt)),
        ));
      }
    }

    try {
      // Make POST request with form data
      print(formData);
      return await _dio.put(
        '/v1/service/$id',
        data: formData,
      );
    } catch (e) {
      throw Exception("Failed to create service $e");
    }
  }

  Future<Response> getAllServices({
    int? page,
    String? fields,
    int? limit,
    String? search,
    String? sort,
    String? category,
    String? location,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      // Add parameters to the query parameters map if they are not null
      if (page != null) queryParams['page'] = page;
      if (fields != null) queryParams['fields'] = fields;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;

      return await _dio.get('/v1/service', queryParameters: queryParams);
    } catch (e) {
      throw Exception("Failed to fetch services $e");
    }
  }

  Future<Response> getService({required String id}) async {
    try {
      return await _dio.get('/v1/service/$id');
    } catch (e) {
      throw Exception("Failed to fetch service with id: $id | error: $e");
    }
  }

  Future<Response> deleteService({required String id}) async {
    try {
      return await _dio.delete('/v1/service/$id');
    } catch (e) {
      throw Exception("Failed to delete service with id: $id | error: $e");
    }
  }

  Future<Response> getmyService() async {
    try {
      return await _dio.get('/v1/service/getMyService');
    } catch (e) {
      throw Exception("Failed to fetch getmyService | error: $e");
    }
  }
}
