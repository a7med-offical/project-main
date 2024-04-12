// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, unused_local_variable, prefer_const_constructors, avoid_print, unused_field, override_on_non_overriding_member

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';

import '../Colors.dart';
import '../Widget/CustomButton.dart';
import '../Widget/CustomTextFormField.dart';
import 'LoginView.dart';

class RegisterView extends StatefulWidget {
  static String id = '6';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  TextEditingController _textEditingController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.text = _selectedOption ?? '';
  }

  String? email, password, fristName, lastName;
  GlobalKey<FormState> key = GlobalKey();
  String? confirmPassword;
  bool visibility = true;
  bool isLaoding = false;
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  File? file;
  String? url;
  bool upload = false;
  getImageCamera() async {
    final ImagePicker picker = ImagePicker();
// Capture a photo.
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    upload = true;
    setState(() {});

    if (imageCamera != null) {
      file = File(imageCamera.path);
      var imagePicked = basename(imageCamera.path);
      var refStorage =
          FirebaseStorage.instance.ref("images").child(imagePicked);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    upload = false;
    setState(() {});
  }

  getImageGallery() async {
    final ImagePicker picker = ImagePicker();

// Pick an image.
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    upload = true;
    setState(() {});

    if (imageGallery != null) {
      file = File(imageGallery.path);
      var imagePicked = basename(imageGallery.path);
      var refStorage =
          FirebaseStorage.instance.ref("images").child(imagePicked);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    upload = false;
    setState(() {});
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'frist_name': '${fristName}',
          'last_name': '${lastName}',
          'url': url,
          'email': email,
          'bloodType': _textEditingController.text,
          'id': FirebaseAuth.instance.currentUser!.uid,
          // John Doe
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      addUser();
      await credential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber[400],
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context as BuildContext).size.height - 60,
              left: 10,
              right: 10,
            ),
            content: Text(
              'password is too weak',
              style: TextStyle(color: background),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        await Future.delayed(Duration(seconds: 2));
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber[400],
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context as BuildContext).size.height - 60,
              left: 10,
              right: 10,
            ),
            content: Text(
              'this email has already exist',
              style: TextStyle(color: background),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  String? _selectedOption;

  List<String> _options = [
    'A+',
    'A-',
    'AB+',
    'AB-',
    'O-',
    'O+',
    'B+',
    'B-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: ModalProgressHUD(
          opacity: 0.3,
          progressIndicator: CircularProgressIndicator(color: Colors.amber),
          inAsyncCall: isLaoding,
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.amber[400],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            )),
                        child: const Text(
                          ' Sign up',
                          style: TextStyle(
                              color: background,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    upload == false
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: background,
                                    title: Text(
                                      'Profile Photo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  getImageCamera();
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                  color: Colors.amber,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.amber,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  getImageGallery();
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .add_photo_alternate_outlined,
                                                  size: 40,
                                                  color: Colors.amber,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Gallary',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.amber,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Stack(clipBehavior: Clip.none, children: [
                              Align(
                                alignment: Alignment.center,
                                child: url != null
                                    ? CircleAvatar(
                                        foregroundColor: background,
                                        backgroundColor: background,
                                        radius: 70,
                                        backgroundImage: NetworkImage(
                                          url!,
                                          scale: 2.5,
                                        ))
                                    : CircleAvatar(
                                        foregroundColor: background,
                                        backgroundColor: background,
                                        radius: 70,
                                        backgroundImage: NetworkImage(
                                          'https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg',
                                          scale: 2.5,
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: -20,
                                left: (MediaQuery.of(context).size.width / 2) -
                                    30,
                                child: CircleAvatar(
                                  backgroundColor: background,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.amber,
                                      )),
                                ),
                              ),
                            ]),
                          )
                        : Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: CustomTextFormField(
                              onChanged: (value) {
                                fristName = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please type your Frist name';
                                } else {
                                  return null;
                                }
                              },
                              text: 'First Name',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            child: CustomTextFormField(
                              onChanged: (value) {
                                lastName = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please type your Last name';
                                } else {
                                  return null;
                                }
                              },
                              text: 'Last Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please type your Email Adress';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        text: 'Email ',
                        suffixIcon: Icons.email),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please type your Password ';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        text: 'Enter a password',
                        suffixIcon: visibility
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        isVisable: visibility),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pleas type your Password';
                          } else if (value != password) {
                            return 'Password don\'t match';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        text: ' Confirm password',
                        suffixIcon: visibility
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        isVisable: visibility),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        text: 'Register',
                        onTap: () async {
                          setState(() {
                            isLaoding = true;
                          });
                          if (key.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              );
                              addUser();
                              await credential.user!.sendEmailVerification();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: background,
                                    title: Text(
                                      'Verify your email',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Please verify your email to continue registration',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        MaterialButton(
                                          color: Colors.amber,
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.amber[400],
                                                dismissDirection:
                                                    DismissDirection.up,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin: EdgeInsets.only(
                                                  top: 30,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      80,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                content: Container(
                                                  height:
                                                      60, // Adjust the height as needed
                                                  child: Text(
                                                    ' check your email to complete your account ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                            Navigator.pushReplacementNamed(
                                                context, LoginView.id);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              color: background,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                await Future.delayed(Duration(seconds: 2));
                                ScaffoldMessenger.of(context as BuildContext)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.amber[400],
                                    dismissDirection: DismissDirection.up,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context as BuildContext)
                                                  .size
                                                  .height -
                                              60,
                                      left: 10,
                                      right: 10,
                                    ),
                                    content: Text(
                                      'password is too weak',
                                      style: TextStyle(color: background),
                                    ),
                                  ),
                                );
                              } else if (e.code == 'email-already-in-use') {
                                await Future.delayed(Duration(seconds: 2));
                                ScaffoldMessenger.of(context as BuildContext)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.amber[400],
                                    dismissDirection: DismissDirection.up,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context as BuildContext)
                                                  .size
                                                  .height -
                                              60,
                                      left: 10,
                                      right: 10,
                                    ),
                                    content: Text(
                                      'this email has already exist',
                                      style: TextStyle(color: background),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                          await Future.delayed(Duration(seconds: 2));
                          setState(() {
                            isLaoding = false;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account ?',
                          style: TextStyle(fontSize: 17),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginView.id);
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 18,  color: Colors.amber,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
