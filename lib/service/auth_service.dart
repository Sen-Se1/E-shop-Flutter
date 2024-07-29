import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/models/cart_model.dart';
import 'package:e_comerce/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String userName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(userName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future<void> signOut(BuildContext context) async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserIdSF("");
      final cartModel = Provider.of<CartModel>(context, listen: false);
      cartModel.clearCart();
      await firebaseAuth.signOut();
    } catch (e) {
      return;
    }
  }

  //resetPassword
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      final QuerySnapshot snapshot = await DatabaseService().gettingUserData(email);

      if (snapshot.docs.isEmpty) {
        return 'User with email $email not found.';
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Password reset email sent successfully! Please check your email.';

    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred while sending the password reset email.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
    }
  }

}

