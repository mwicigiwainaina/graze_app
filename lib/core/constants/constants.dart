import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// const backgroundColor = Color.fromRGBO(194, 254, 179, 1);
const backgroundColor = Color.fromRGBO(32, 33, 35, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(255, 255, 255, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Color.fromRGBO(255, 255, 255, 1);
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1);

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

class PageConst {
  static const String editProfilePage = "editProfilePage";
  static const String updatePostPage = "updatePostPage";
  static const String commentPage = "commentPage";
  static const String signInPage = "signInPage";
  static const String signUpPage = "signUpPage";
  static const String updateCommentPage = "updateCommentPage";
  static const String updateReplyPage = "updateReplyPage";
  static const String postDetailPage = "postDetailPage";
  static const String singleUserProfilePage = "singleUserProfilePage";
  static const String followingPage = "followingPage";
  static const String followersPage = "followersPage";
}

class FirebaseConst {
  static const String users = "users";
  static const String posts = "posts";
  static const String comment = "comment";
  static const String reply = "reply";
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blueColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
