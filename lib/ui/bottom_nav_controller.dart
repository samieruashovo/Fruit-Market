import 'package:e_commerce_app/const/app_colors.dart';
import 'package:e_commerce_app/ui/pages/cart.dart';
import 'package:e_commerce_app/ui/pages/favorite.dart';
import 'package:e_commerce_app/ui/pages/seller/sell_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/profile.dart';

class BottonNavController extends StatefulWidget {
  const BottonNavController({Key? key}) : super(key: key);

  @override
  State<BottonNavController> createState() => _BottonNavControllerState();
}

class _BottonNavControllerState extends State<BottonNavController> {
  final _pages = [
    const Home(),
    const Favourite(),
    const Cart(),
    const Profile(),
    const SellItem()
  ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Fruit Market',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: AppColors.deep_orange,
                ),
                label: const Text("Logout", style: TextStyle(color: AppColors.deep_orange),))
          ]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Person",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_sharp),
            label: "Sell",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
