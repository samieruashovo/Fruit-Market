import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/const/app_colors.dart';
import 'package:e_commerce_app/ui/pages/seller/post.dart';
import 'package:e_commerce_app/ui/pages/seller/upload_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SellItem extends StatefulWidget {
  const SellItem({Key? key}) : super(key: key);

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;

  XFile? pickedImage;

  Future<void> _upload(
      File imageFile, String name, String price, String description) async {
    String postId = const Uuid().v1();

    try {
      String photoUrl = await uploadImageToStorage(imageFile, name);
      Post post = Post(
          name: name,
          description: description,
          price: price,
          postUrl: photoUrl);

      FirebaseFirestore.instance
          .collection('products')
          .doc(postId) //currentUser!.email
          .set(post.toJson());
      Fluttertoast.showToast(msg: 'Uploaded successfuly');
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  // Future<void> _delete(String ref) async {
  //   await storage.ref(ref).delete();
  //   setState(() {});
  // }
  _gallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Widget? pickImageFromGallery() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              _gallery();
            },
            icon: const Icon(
              Icons.camera,
            ),
            label: const Text('Gallery'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.deep_orange)),
          ),
        ],
      ),
    );
  }

  Widget? addDescription() {
    TextEditingController? _name = TextEditingController();
    TextEditingController? _details = TextEditingController();
    TextEditingController? _price = TextEditingController();
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30.h, width: 30.w, child: Image.file(imageFile!)),
          SizedBox(
            height: 15.h,
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: 'Enter your product name'),
            controller: _name,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: 'Enter your product price'),
            controller: _price,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: 'Enter your product details'),
            controller: _details,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _upload(imageFile!, _name.text, _price.text, _details.text),
            icon: const Icon(Icons.backup_outlined ),
            label: const Text('Upload'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sell your items'),
      //   backgroundColor: AppColors.deep_orange,
      // ),
      body: imageFile == null ? pickImageFromGallery() : addDescription(),
    );
  }
}


//                    ElevatedButton.icon(
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all(AppColors.deep_orange)),
//                 onPressed: () => _upload('camera'),
//                 icon: const Icon(
//                   Icons.camera,
//                 ),
//                 label: const Text('camera'),
//               ),
