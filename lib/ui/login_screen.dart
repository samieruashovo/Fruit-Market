import 'package:e_commerce_app/const/app_colors.dart';
import 'package:e_commerce_app/ui/bottom_nav_controller.dart';
import 'package:e_commerce_app/ui/register_screen.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscureText = true;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCedential = userCredential.user;
      if (authCedential!.uid.isNotEmpty) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BottonNavController()));
      } else {
        Fluttertoast.showToast(msg: 'Something went Wrong');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
     // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Container(
            width: ScreenUtil().screenWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 22.sp, color: AppColors.deep_orange),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 48.h,
                          width: 41.w,
                          decoration: BoxDecoration(
                              color: AppColors.deep_orange,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Center(
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 20.w,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'someone@email.com',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF414041),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.deep_orange,
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 48.h,
                          width: 41.w,
                          decoration: BoxDecoration(
                              color: AppColors.deep_orange,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Center(
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 20.w,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password must be at least 6 character',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF414041),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.deep_orange,
                            ),
                            suffixIcon: _obscureText == true
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      size: 20.w,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.visibility_off,
                                      size: 20.w,
                                    )),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    customButton(
                      "Sign In",
                      () {
                        signIn();
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: Wrap(
                        children: [
                          Text('Dont have an account?',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFBBBBBB),
                              )),
                          GestureDetector(
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deep_orange,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ));
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
