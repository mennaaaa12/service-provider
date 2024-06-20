import 'dart:convert';

import 'package:worker/models/user_model.dart';

class Booking {
  final String id;
  final String serviceId;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final BookingAddress address;
  final String status;
  final String? rejectReason;
  final User user; // Add user object
  final bool ispaid;

  Booking({
    required this.id,
    required this.serviceId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.address,
    required this.status,
    required this.user, // Include user object
    required this.ispaid,
    this.rejectReason,
  });

  // Method to format date without hours
  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json["_id"] ?? "",
      serviceId: json['serviceId'] ?? "",
      description: json['description'] ?? "",
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      address: BookingAddress.fromJson(json['address'] ?? {}),
      status: json['status'] ?? "",
      rejectReason: json['rejectReason'],
      ispaid: json['isPaid'],
      user: User.fromJson(json['user']), // Parse user object
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'serviceId': serviceId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'price': price,
      'address': address.toJson(),
      'status': status,
      'user': user.toJson(), // Convert user object to JSON
    };
    if (rejectReason != null) data['rejectReason'] = rejectReason;
    return data;
  }

  static List<Booking> parseBookings(dynamic responseBody) {
    final Map<String, dynamic> parsed = responseBody;
    if (parsed.containsKey('data') && parsed['data'].containsKey('docs')) {
      final List<dynamic> docs = parsed['data']['docs'];
      return docs.map<Booking>((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Invalid or empty response data');
    }
  }
}

class BookingAddress {
  final String details;
  final String phone;
  final String city;
  final String postalCode;

  BookingAddress({
    required this.details,
    required this.phone,
    required this.city,
    required this.postalCode,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) {
    return BookingAddress(
      details: json['details'] ?? "",
      phone: json['phone'] ?? "",
      city: json['city'] ?? "",
      postalCode: json['postalCode'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details,
      'phone': phone,
      'city': city,
      'postalCode': postalCode,
    };
  }
}
