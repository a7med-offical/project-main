

import 'dart:io';

import 'package:bldapp/view/DonationView.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OCR_View extends StatefulWidget {
  @override
  _OCR_ViewState createState() => _OCR_ViewState();
}

class _OCR_ViewState extends State<OCR_View>
    with SingleTickerProviderStateMixin {
  File? _image;
  final picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

 Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR'),
      ),
    body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return DonationView();
              }));
            },
            child: Text('Animate Image'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}