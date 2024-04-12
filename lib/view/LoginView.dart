// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, must_be_immutable, unused_local_variable, use_build_context_synchronously, avoid_print, body_might_complete_normally_nullable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Colors.dart';
import '../Widget/CustomButton.dart';
import '../Widget/CustomTextFormField.dart';
import 'RegisterView.dart';
import 'ServiceView.dart';

class LoginView extends StatefulWidget {
  static String id = '3';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? email, password;
  bool isLoadibg = false;
  String? resetEmail;
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> alerDialogKey = GlobalKey();
  bool Visabilty = true;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Navigator.pushReplacementNamed(context, ServiceView.id);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  IconData Icon = Icons.remove_red_eye;
  Future<void> _loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null && user.emailVerified) {
          await Future.delayed(Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, ServiceView.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber[400],
              dismissDirection: DismissDirection.up,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 10,
                right: 10,
              ),
              content: Text(
                'Login Successful',
                style: TextStyle(color: background),
              ),
            ),
          );
        } else if (user != null) {
          await Future.delayed(Duration(seconds: 2));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber[400],
              dismissDirection: DismissDirection.up,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                top: 30,
                bottom: MediaQuery.of(context).size.height - 80,
                left: 10,
                right: 10,
              ),
              content: Text(
                'Login Failed: Email not verified',
                style:
                    TextStyle(color: background, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[400],
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              top: 30,
              bottom: MediaQuery.of(context).size.height - 80,
              left: 10,
              right: 10),
          content: Text('Please, Enter correct email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: background,
              )),
        ));
      } else if (e.code == 'wrong-password') {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[400],
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              top: 30,
              bottom: MediaQuery.of(context).size.height - 80,
              left: 10,
              right: 10),
          content: Text('Please, Enter correct password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: background,
              )),
        ));
      } else if (e.code == 'invalid-email') {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[400],
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              top: 30,
              bottom: MediaQuery.of(context).size.height - 80,
              left: 10,
              right: 10),
          content: Text('This email is not vaild',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: background,
              )),
        ));
      } else {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[400],
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              top: 30,
              bottom: MediaQuery.of(context).size.height - 80,
              left: 10,
              right: 10),
          content: Text('Please check your email or password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: background,
              )),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      opacity: 0.3,
      progressIndicator: CircularProgressIndicator(color: Colors.amber),
      inAsyncCall: isLoadibg,
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                Container(
                    height: 260,
                    width: double.infinity,
                    child: Image.asset(
                      'Assets/Images/image4.jpeg',
                      fit: BoxFit.fill,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          'Welcome To BLD',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        'Login to discover more services ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 8),
                            child: Text(
                              'Email Adress',
                            ),
                          )),
                      CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please type your Email Adress ';
                          } else if (FirebaseAuth
                              .instance.currentUser!.email!.isEmpty) {
                            return 'null';
                          }
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        text: 'Enter your email',
                        suffixIcon: Icons.email,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 8),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )),
                      CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please type your password   ';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        text: 'Enter you password',
                        isVisable: Visabilty,
                        suffixIcon: Visabilty ? Icons.visibility_off : Icon,
                        onPressed: () {
                          setState(() {
                            Visabilty = !Visabilty;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AlertDialog(
                                          backgroundColor: background,
                                          title: Text(
                                            'Reset password',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Form(
                                            key: alerDialogKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Please, Enter your email to reset password',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextFormField(
                                                  onChanged: (value) {
                                                    resetEmail = value;
                                                  },
                                                  text: 'Enter your email',
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please type your email';
                                                    } else if (FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email ==
                                                        null) {
                                                      return 'User not found';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoadibg = true;
                                                    });
                                                    try {
                                                      if (alerDialogKey
                                                          .currentState!
                                                          .validate()) {
                                                        await FirebaseAuth
                                                            .instance
                                                            .sendPasswordResetEmail(
                                                                email:
                                                                    resetEmail!);
                                                        await Future.delayed(
                                                            Duration(
                                                                seconds: 2));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          dismissDirection:
                                                              DismissDirection
                                                                  .up,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          margin: EdgeInsets.only(
                                                              top: 30,
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height -
                                                                  80,
                                                              left: 10,
                                                              right: 10),
                                                          content: Text(
                                                              'Please check you email to reset password',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ));
                                                      }
                                                    } catch (e) {
                                                      await Future.delayed(
                                                          Duration(seconds: 2));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        dismissDirection:
                                                            DismissDirection.up,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin: EdgeInsets.only(
                                                            top: 30,
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                80,
                                                            left: 10,
                                                            right: 10),
                                                        content: Text(
                                                            'Sorry , this email not found try again',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    background)),
                                                      ));
                                                    }
                                                    Navigator.pop(context);
                                                    await Future.delayed(
                                                        Duration(seconds: 2));
                                                    setState(() {
                                                      isLoadibg = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    'Send',
                                                    style: TextStyle(
                                                        color: background),
                                                  ),
                                                  color: Colors.amber,
                                                )
                                              ],
                                            ),
                                          )));
                                });
                          },
                          child: Text('Forget Password ?',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: 'Sign in',
                          onTap: () async {
                            setState(() {
                              isLoadibg = true;
                            });
                            if (key.currentState!.validate()) {
                                             await FirebaseMessaging.instance
                                               .subscribeToTopic('bloodType');
                              await _loginWithEmailAndPassword(
                                  email!, password!);
                            }
                            await Future.delayed(Duration(seconds: 2));
                            setState(() {
                              isLoadibg = false;
                            });
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const Text(
                            ' Or Login with ',
                            style: TextStyle(fontSize: 17),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You don\'t have an account?',
                            style: TextStyle(fontSize: 17),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RegisterView.id);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.amber),
                              ))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
