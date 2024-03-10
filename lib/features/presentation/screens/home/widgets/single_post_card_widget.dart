import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/app_entity.dart';
import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
import 'package:graze_app/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:graze_app/features/presentation/screens/home/widgets/review_widget.dart';
import 'package:graze_app/features/presentation/screens/posts/widgets/like_animation_widget.dart';
import 'package:graze_app/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:graze_app/features/presentation/screens/home/widgets/review_widget.dart';
import 'package:graze_app/injection_container.dart' as di;

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.singleUserProfilePage,
                      arguments: widget.post.creatorUid);
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: profileWidget(
                            imageUrl: "${widget.post.userProfileUrl}"),
                      ),
                    ),
                    sizeHor(10),
                    Text(
                      "${widget.post.username}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModalSheet(context, widget.post);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ))
                  : Container(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
          sizeVer(10),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                      duration: const Duration(milliseconds: 200),
                      isLikeAnimating: _isLikeAnimating,
                      onLikeFinish: () {
                        setState(() {
                          _isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        size: 100,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
            ),
            child: FoodReviewWidget(
              dishName: widget.post.dishName!,
              distance: widget.post.distance!,
              restaurant: widget.post.restaurant!,
              rating: widget.post.rating!,
              description: widget.post.description!,
            ),
          ),
          sizeVer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: _likePost,
                      child: Icon(
                        widget.post.likes!.contains(_currentUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.post.likes!.contains(_currentUid)
                            ? Colors.red
                            : primaryColor,
                      )),
                  sizeHor(10),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.commentPage,
                            arguments: AppEntity(
                                uid: _currentUid, postId: widget.post.postId));
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()));
                      },
                      child: const Icon(
                        Icons.chat_bubble_rounded,
                        color: primaryColor,
                      )),
                  sizeHor(10),
                  const Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                ],
              ),
              const Icon(
                Icons.bookmark_border,
                color: primaryColor,
              )
            ],
          ),
          sizeVer(10),
          Text(
            "${widget.post.totalLikes} likes",
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          sizeVer(10),
          Row(
            children: [
            ],
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PageConst.commentPage,
                    arguments: AppEntity(
                        uid: _currentUid, postId: widget.post.postId));
              },
              child: Text(
                "View all ${widget.post.totalComments} comments",
                style: const TextStyle(color: Colors.white),
              )),
          sizeVer(10),
          Text(
            "${DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate())}",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  _openBottomModalSheet(BuildContext context, PostEntity post) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: backgroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: _deletePost,
                        child: const Text(
                          "Delete Post",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    sizeVer(7),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.updatePostPage,
                              arguments: post);

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                        },
                        child: const Text(
                          "Update Post",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.post.postId));
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graze_app/core/constants/constants.dart';
// import 'package:graze_app/features/domain/entities/app_entity.dart';
// import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
// import 'package:graze_app/features/domain/usecases/user/get_current_uid_usecase.dart';
// import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
// import 'package:graze_app/features/presentation/screens/home/widgets/review_widget.dart';
// import 'package:graze_app/features/presentation/screens/posts/widgets/like_animation_widget.dart';
// import 'package:graze_app/profile_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:graze_app/injection_container.dart'as di;

// class SinglePostCardWidget extends StatefulWidget {
//   final PostEntity post;
//   const SinglePostCardWidget({Key? key, required this.post}) : super(key: key);

//   @override
//   State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
// }

// class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {

//   String _currentUid = "";

//   @override
//   void initState() {
//     di.sl<GetCurrentUidUseCase>().call().then((value) {
//       setState(() {
//         _currentUid = value;
//       });
//     });
//     super.initState();
//   }

//   bool _isLikeAnimating = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, PageConst.singleUserProfilePage, arguments: widget.post.creatorUid);
//                   },
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: profileWidget(imageUrl: "${widget.post.userProfileUrl}"),
//                         ),
//                       ),
//                       sizeHor(10),
//                       Text("${widget.post.username}", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),)
//                     ],
//                   ),
//                 ),
//                 widget.post.creatorUid == _currentUid ?GestureDetector(onTap: () {
//                   _openBottomModalSheet(context, widget.post);
//                 },child: const Icon(Icons.more_vert, color: primaryColor,)) : Container(width: 0, height: 0,)
//               ],
//             ),
//             sizeVer(10),
//             GestureDetector(
//               onDoubleTap: () {
//                 _likePost();
//                 setState(() {
//                   _isLikeAnimating = true;
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height * 0.30,
//                     child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
//                   ),
//                   AnimatedOpacity(
//                     duration: const Duration(milliseconds: 200),
//                     opacity: _isLikeAnimating? 1 : 0,
//                     child: LikeAnimationWidget(
//                      duration: const Duration(milliseconds: 200),
//                     isLikeAnimating: _isLikeAnimating,
//                     onLikeFinish: () {
//                        setState(() {
//                          _isLikeAnimating = false;
//                        });
//                     },
//                     child: const Icon(Icons.favorite, size: 100, color: Colors.white,)),
//                   ),
//                 ],
//               ),
//             ),
// sizeVer(10),
// Container(
//   padding: EdgeInsets.all(8.0),
//   decoration: BoxDecoration(
//     color: Colors.grey.withOpacity(0.2),
//     borderRadius: BorderRadius.circular(8.0),
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     child: FoodReviewWidget
//   //   children: [
//   //     Text(
//   //       'Dish Name: ',
//   //       // 'Dish Name: ${singlePost.dishName}',
//   //       style: TextStyle(
//   //         color: primaryColor,
//   //         fontWeight: FontWeight.bold,
//   //       ),
//   //     ),
//   //     sizeVer(4),
//   //     Text(
//   //       'Distance: 5km',
//   //       // 'Distance: ${singlePost.distance} km',
//   //       style: TextStyle(color: primaryColor),
//   //     ),
//   //     sizeVer(4),
//   //     Text(
//   //     'Restaurant:',
//   //     //  'Restaurant: ${singlePost.restaurant}',
//   //       style: TextStyle(color: primaryColor),
//   //     ),
//   //     sizeVer(4),
//   //     Row(
//   //       children: [
//   //         Icon(
//   //           Icons.star,
//   //           color: Colors.yellow,
//   //           size: 16.0,
//   //         ),
//   //         sizeHor(4),
//   //         Text(
//   //           'Rating:',
//   //           // '${singlePost.rating}',
//   //           style: TextStyle(color: primaryColor),
//   //         ),
//   //       ],
//   //     ),
//   //   ],
//   ),
// ),

//             // Container(
//             //   height: MediaQuery.of(context).size.height * 0.168, // Adjust the height as needed
//             //   decoration: BoxDecoration(
//             //     color: Colors.blue,  // Set the color as needed
//             //     borderRadius: BorderRadius.only(
//             //         topLeft: Radius.circular(1.0),
//             //         topRight: Radius.circular(1.0),
//             //     )
//             //   )
//             // ),

//             sizeVer(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(onTap: _likePost,child: Icon(widget.post.likes!.contains(_currentUid)?Icons.favorite : Icons.favorite_outline, color: widget.post.likes!.contains(_currentUid)? Colors.red : primaryColor,)),
//                     sizeHor(10),
//                     GestureDetector(onTap: () {
//                       Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: widget.post.postId));
//                       //Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()));
//                     },child: const Icon(Icons.chat_bubble_rounded, color: primaryColor,)),
//                     sizeHor(10),
//                     const Icon(Icons.send, color: primaryColor,),
//                   ],
//                 ),
//                 const Icon(Icons.bookmark_border, color: primaryColor,)

//               ],
//             ),
//             sizeVer(10),
//             Text("${widget.post.totalLikes} likes", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
//             sizeVer(10),
//             Row(
//               children: [
//                 Text("${widget.post.username}", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
//                 sizeHor(10),
//                 Text("${widget.post.description}", style: const TextStyle(color: primaryColor),),
//               ],
//             ),
//             sizeVer(10),
//             GestureDetector(onTap: () {
//               Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: widget.post.postId));

//             },child: Text("View all ${widget.post.totalComments} comments", style: const TextStyle(color: Colors.white),)),
//             sizeVer(10),
//             Text("${DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate())}", style: const TextStyle(color: Colors.white),),

//           ],
//         ),
//       );
//   }

//   _openBottomModalSheet(BuildContext context, PostEntity post) {
//     return showModalBottomSheet(context: context, builder: (context) {
//       return Container(
//             height: 150,
//             decoration: BoxDecoration(color: backgroundColor.withOpacity(.8)),
//             child: SingleChildScrollView(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(left: 10.0),
//                       child: Text(
//                         "More Options",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     const Divider(
//                       thickness: 1,
//                       color: secondaryColor,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: GestureDetector(
//                         onTap: _deletePost,
//                         child: const Text(
//                           "Delete Post",
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
//                         ),
//                       ),
//                     ),
//                     sizeVer(7),
//                     const Divider(
//                       thickness: 1,
//                       color: secondaryColor,
//                     ),
//                     sizeVer(7),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, PageConst.updatePostPage, arguments: post);

//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));

//                         },
//                         child: const Text(
//                           "Update Post",
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
//                         ),
//                       ),
//                     ),
//                     sizeVer(7),
//                   ],
//                 ),
//               ),
//             ),
//           );
//     });
//   }

//   _deletePost() {
//     BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.post.postId));
//   }

//   _likePost() {
//     BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
//       postId: widget.post.postId
//     ));
//   }
// }
