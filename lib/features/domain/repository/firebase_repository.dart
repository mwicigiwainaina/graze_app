import 'dart:io';
import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
import 'package:graze_app/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRepository {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnFollowUser(UserEntity user);

    // Cloud Storage Feature
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
}
