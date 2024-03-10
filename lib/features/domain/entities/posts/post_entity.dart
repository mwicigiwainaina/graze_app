import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;
  final String? dishName;
  final String? distance;
  final String? restaurant;
  final String? rating;

  PostEntity({
    this.postId,
    this.creatorUid,
    this.username,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
    this.dishName,
    this.distance,
    this.restaurant,
    this.rating,

    //add fields from fremote database impl.
  });

  @override
  // TODO: implement props
  // what are props
  List<Object?> get props => [
    postId,
    creatorUid,
    username,
    description,
    postImageUrl,
    likes,
    totalLikes,
    totalComments,
    createAt,
    userProfileUrl,
    dishName,
    distance,
    restaurant,
    rating,
  ];

  
}
