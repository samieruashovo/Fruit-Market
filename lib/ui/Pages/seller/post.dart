import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String description;
  final String price;
  final String postUrl;

  Post(
      {required this.name,
      required this.description,
      required this.price,
      required this.postUrl});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      name: snapshot["product-name"],
      description: snapshot["product-description"],
      price: snapshot["product-price"],
      postUrl: snapshot["product-img"],
    );
  }

  Map<String, dynamic> toJson() => {
        "product-name": name,
        "product-description": description,
        "product-price": price,
        "product-img": postUrl,
      };
}
