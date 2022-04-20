import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/const/app_colors.dart';
import 'package:e_commerce_app/ui/bottom_nav_controller.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';
import 'package:e_commerce_app/widgets/myTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _genderController = TextEditingController();
    _ageController = TextEditingController();

    super.initState();
  }

  List<String> gender = ["Male", "Female", "Other"];
  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year - 30),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
    }
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const BottonNavController())))
        .catchError((error) => Fluttertoast.showToast(msg: "Something went wrong"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Submit the form to continue',
              style: TextStyle(fontSize: 22.sp, color: AppColors.deep_orange),
            ),
            Text(
              'We wll not share your information with anyone',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFBBBBBB),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            myTextField("enter your name", TextInputType.text, _nameController),
            myTextField("enter your phone number", TextInputType.number,
                _phoneController),
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'Date of Birth',
                  suffixIcon: IconButton(
                    onPressed: () => _selectDateFromPicker(context),
                    icon: const Icon(Icons.calendar_today_outlined),
                  )),
            ),
            TextField(
              controller: _genderController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'choose your gender',
                prefixIcon: DropdownButton<String>(items: gender.map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    onTap: (){setState(() {
                      _genderController.text = value;
                    });},
                    );
                }).toList(), onChanged: (_){}),
              ),
            ),
            myTextField('enter your age', TextInputType.number,_ageController),
            SizedBox(
                  height: 50.h,
                ),
                customButton("Continue",()=>sendUserDataToDB()),
          ],
        ),
      )),
    );
  }
}
