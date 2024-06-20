class Service {
  final String id;
  final String title;
  final String description;
  final String category;
  final String categoryid;
 // final double price;
  final double? priceAfterDiscount;
  final String coverImage;
  final String location;
  final List<String>? images;
   double? ratingsAverage;
  final int ratingsQuantity;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryid,
  //  required this.price,
    this.priceAfterDiscount,
    required this.coverImage,
    this.images,
    this.ratingsAverage,
    required this.ratingsQuantity,
    required this.location,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
  return Service(
    id: json["_id"],
    title: json['title'],
    description: json['description'],
    category: json['category']['name'],
    categoryid: json['category']["_id"], // Accessing the 'name' property of the category object
 // Accessing the 'name' property of the category object
  //  price: json['price'].toDouble(),
    priceAfterDiscount: json['priceAfterDiscount']?.toDouble(),
    coverImage: json['coverImage'],
    images: json['images'] != null ? List<String>.from(json['images']) : null,
    ratingsAverage: json['ratingsAverage']?.toDouble(),
    ratingsQuantity: json['ratingsQuantity'],
    location: json['location'],
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      //'price': price,
      'coverImage': coverImage,
      'ratingsQuantity': ratingsQuantity,
      'location': location,
      'categoryid': categoryid,
    };
    if (priceAfterDiscount != null) data['priceAfterDiscount'] = priceAfterDiscount;
    if (images != null) data['images'] = images;
    if (ratingsAverage != null) data['ratingsAverage'] = ratingsAverage;
    return data;
  }
}
