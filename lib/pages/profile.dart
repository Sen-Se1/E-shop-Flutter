import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/pages/changePassword.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/service/Database_service.dart';
import 'package:e_comerce/service/auth_service.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  String address = "";
  String phoneNumber = "";
  String? imageUrl;
  File? _image;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    DatabaseService dbService = DatabaseService();
    QuerySnapshot userSnap = await dbService.gettingUserData(email);
    if (userSnap.docs.isNotEmpty) {
      var userDoc = userSnap.docs[0];

      setState(() {
        userName = userDoc['userName'];
        address = userDoc['address'] ?? '';
        phoneNumber = userDoc['phoneNumber'] ?? '';
        imageUrl = userDoc['profilePic'] ?? '';

        userNameController.text = userName;
        emailController.text = email;
        phoneNumberController.text = phoneNumber;
        addressController.text = address;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      String? updatedImageUrl;

      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user?.uid}.jpg');
        final uploadTask = await storageRef.putFile(_image!);
        updatedImageUrl = await uploadTask.ref.getDownloadURL();
      }

      DatabaseService dbService = DatabaseService();
      QuerySnapshot userSnap = await dbService.gettingUserData(email);
      if (userSnap.docs.isNotEmpty) {
        var userDoc = userSnap.docs[0];
        await dbService.userCollection.doc(userDoc.id).update({
          'userName': userName,
          'address': address,
          'phoneNumber': phoneNumber,
          'profilePic': updatedImageUrl ?? imageUrl,
        });

        await HelperFunctions.saveUserNameSF(userName);
        showSnackbar(context, Colors.green, 'Profile updated successfully');
        nextScreen(context, const NavbarPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants().primaryColor,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            nextScreen(context, const NavbarPage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Stack(
                    children: [
                      _image == null
                          ? (imageUrl == null
                          ? const Icon(
                        Icons.account_circle,
                        size: 160,
                        color: Colors.grey,
                      )
                          : CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(imageUrl!),
                      ))
                          : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(_image!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.grey, size: 30),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
            Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:userNameController,
                  decoration: textInputDecoration.copyWith(
                    hintText: "UserName",
                    suffixIcon: const Icon(Icons.account_box_rounded,
                        color: Colors.black12),
                  ),
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Username cannot be empty";
                    }
                  },
                ),
              ),
            ),
          ),

                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller:emailController,
                        enabled: false,
                        decoration: textInputDecoration.copyWith(
                          hintText: "Email...",
                          suffixIcon: const Icon(Icons.email_outlined,
                              color: Colors.black12),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: addressController,
                    decoration: textInputDecoration.copyWith(
                      hintText: "Adress",
                      suffixIcon: const Icon(Icons.home_filled,
                          color: Colors.black12),
                    ),
                    onChanged: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                  ),
                ),
              ),
            ),
                const SizedBox(
                  height: 16,
                ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: phoneNumberController,
                    decoration: textInputDecoration.copyWith(
                      hintText: "Phone Number",
                      suffixIcon: const Icon(Icons.phone_android_rounded,
                          color: Colors.black12),
                    ),
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only digits';
                        }
                        if (value.length != 8) {
                          return 'Phone number must be 8 digits long';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),


                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Profile', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants().primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    nextScreen(context, const ChangePasswordPage());
                  },
                  child: const Text('Change Password', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants().primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
