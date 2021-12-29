// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'model/model.dart';

class TakeImage extends StatefulWidget {
  const TakeImage({Key? key, this.userData}) : super(key: key);
  final UserInfo? userData;
  @override
  _TakeImageState createState() => _TakeImageState();
}

class _TakeImageState extends State<TakeImage> {
  File? _image;

  void updateUserInfo(String name, String email, String pass) async {
    http.Response response = await http.post(
      Uri.parse("http://localhost:8080/api/v1/users/${widget.userData!.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "fullName": "$name",
          "emailid": "$email",
          "password": "$pass",
        },
      ),
    );
    if (response.statusCode == 200) {
      print(response.body);
      print('Successfully saved');
    } else {
      throw Exception("Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Capture Image'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
// backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text("${widget.userData!.fullName}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 30,
              ),
              Stack(children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        decoration: BoxDecoration(
                          // color: BrandColors.colorPrimary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: _image == null
                            ? IconButton(
                                onPressed: () {
                                  // selectImage(context);
                                  selectImage(context);
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 90,
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 270,
                                        // width: double.infinity,
                                        decoration: BoxDecoration(
                                          // color: Colors.black.withOpacity(0.4),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          border: Border.all(
                                              color: Colors.black, width: 1.0),
                                          image: DecorationImage(
                                            image: FileImage(_image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        // : Image.file(
                        //     image,
                        //     fit: BoxFit.cover,
                        //   ),
                        ),
                  ),
                ),
                Positioned(
                  right: -15,
                  top: -15,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    icon: _image != null
                        ? Icon(
                            Icons.clear,
                            color: Colors.red,
                            // size: 20,
                          )
                        : Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Text(
                'Add your profile photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                //  style: myStyle(14,BrandColors.colorText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  Future getImageGallery() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  Future getImageCamera() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Upload Image",
              style: TextStyle(),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () {
                  print("Gallery");
                  getImageGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Image from Camera"),
                onPressed: () {
                  print("open camera");
                  getImageCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
