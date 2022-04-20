import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/const/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  final String productImg;
  final String name;
  final String price;
  final String details;

  const ProductDetails(
      {required this.productImg,
      Key? key,
      required this.name,
      required this.price,
      required this.details})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget.name,
      "price": widget.price,
      "images": widget.productImg,
    }).then((value) => Fluttertoast.showToast(msg: "Added to cart"));
  }

  Future addToFavorite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget.name,
      "price": widget.price,
      "images": widget.productImg,
    }).then((value) => Fluttertoast.showToast(msg: "Added to Favorite"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-favorite-items")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .where("name", isEqualTo: widget.name)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Text("");
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: () {
                        snapshot.data.docs.length == 0
                            ? addToFavorite()
                            : Fluttertoast.showToast(msg: "Already added");
                      },
                      icon: snapshot.data.docs.length == 0
                          ? const Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                    ),
                  ),
                );
              })
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.network(widget.productImg),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Name: ${widget.name}",
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Price: \$${widget.price}",
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Details: ${widget.details}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Divider(),
                            SizedBox(
                              width: 1.sw,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed: () => addToCart(),
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.sp),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.deep_orange,
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
              /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                  items: widget.product['product-img']
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                                decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth),
                            )),
                          )).toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {});
                      })),
            ),
            Text(
              widget.product['product-name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(widget.product['product-description']),
            const SizedBox(
              height: 10,
            ),
            Text(
              "\$ ${widget.product['product-price']}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            const Divider(),
            SizedBox(
              width: 1.sw,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => addToCart(),
                child: Text(
                  "Add to cart",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.deep_orange,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
        */
              )),
    );
  }
}
