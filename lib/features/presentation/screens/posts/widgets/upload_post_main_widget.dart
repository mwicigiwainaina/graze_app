
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
import 'package:graze_app/features/domain/entities/user/user_entity.dart';
import 'package:graze_app/features/domain/usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:graze_app/features/presentation/screens/profile/widgets/profile_form_widget.dart';
import 'package:graze_app/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:graze_app/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {

  File? _image;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dishNameController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  TextEditingController _restaurantController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _dishNameController.dispose();
    _ratingController.dispose();
    _distanceController.dispose();
    _restaurantController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
Widget build(BuildContext context) {
  return _image == null ? _uploadPostWidget() : Scaffold(
    backgroundColor: backgroundColor,
    appBar: AppBar(
      backgroundColor: backgroundColor,
      leading: GestureDetector(onTap: () => setState(() => _image = null), child: Icon(Icons.close, size: 28,)),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(onTap: _submitPost, child: Icon(Icons.arrow_forward)),
        )
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              child: ClipRRect(borderRadius: BorderRadius.circular(40), child: profileWidget(imageUrl: "${widget.currentUser.profileUrl}")),
            ),
            sizeVer(10),
            Text("${widget.currentUser.username}", style: TextStyle(color: Colors.white),),
            sizeVer(10),
            Container(
              width: double.infinity,
              height: 200,
              child: profileWidget(image: _image),
            ),
            sizeVer(10),
            ProfileFormWidget(title: "Description", controller: _descriptionController,),
            sizeVer(10),
            ProfileFormWidget(title: "Dish Name", controller: _dishNameController,),
            sizeVer(10),
            ProfileFormWidget(title: "Restaurant", controller: _restaurantController,),
            sizeVer(10),
            ProfileFormWidget(title: "Distance", controller: _distanceController,),
            sizeVer(10),
            ProfileFormWidget(title: "Rating", controller: _ratingController,),
            sizeVer(10),
            _uploading == true ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Uploading...", style: TextStyle(color: Colors.white),),
                sizeHor(10),
                CircularProgressIndicator()
              ],
            ) : Container(width: 0, height: 0,)
          ],
        ),
      ),
    ),
  );
}

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    di.sl<UploadImageToStorageUseCase>().call(_image!, true, "posts").then((imageUrl) {
      _createSubmitPost(image: imageUrl);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context).createPost(
        post: PostEntity(
            description: _descriptionController.text,
            dishName: _dishNameController.text,
            rating: _ratingController.text,
            distance: _distanceController.text,
            restaurant: _restaurantController.text,
            createAt: Timestamp.now(),
            creatorUid: widget.currentUser.uid,
            likes: [],
            postId: Uuid().v1(),
            postImageUrl: image,
            totalComments: 0,
            totalLikes: 0,
            username: widget.currentUser.username,
            userProfileUrl: widget.currentUser.profileUrl
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _uploading = false;
      _descriptionController.clear();
      _restaurantController.clear();
      _ratingController.clear();
      _dishNameController.clear();
      _distanceController.clear();
      _image = null;
    });
  }

  _uploadPostWidget() {
    return Scaffold(
        backgroundColor: backgroundColor,

        body: Center(
          child: GestureDetector(
            onTap: selectImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(.3),
                  shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(Icons.upload, color: primaryColor, size: 40,),
              ),
            ),
          ),
        )
    );
  }
}
