class User {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImage;
  final String? phone;
  final String role;
  final double? balance;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImage,
    this.phone,
    required this.role,
    this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"],
        name: json['name'],
        email: json['email'],
        bio: json['bio'],
        profileImage: json['profileImage'],
        phone: json['phone'],
        role: json['role'],
        balance: (json['data']?['providerAccount']?['balance'] as num?)?.toDouble(),       );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'role': role,
    };
    if (bio != null) data['bio'] = bio;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (phone != null) data['phone'] = phone;
data['data'] = {
      'providerAccount': {
        'balance': balance,
      }
    };
    
    return data;
  }
}