import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/comment/comment_entity.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/entities/user/user_entity.dart';
import 'package:graze_app/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:graze_app/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:graze_app/features/presentation/screens/posts/comment/widget/single_reply_widget.dart';
import 'package:graze_app/features/presentation/widgets/form_container_widget.dart';
import 'package:graze_app/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:graze_app/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

  const SingleCommentWidget(
      {Key? key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickListener,
      this.currentUser})
      : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  TextEditingController _replyDescriptionController = TextEditingController();
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    BlocProvider.of<ReplyCubit>(context).getReplys(
        reply: ReplyEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId));

    super.initState();
  }

  bool _isUserReplying = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.comment.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.comment.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : darkGreyColor,
                            ))
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.comment.description}",
                      style: TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    Row(
                      children: [
                        Text(
                          "${DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate())}",
                          style: TextStyle(color: darkGreyColor),
                        ),
                        sizeHor(15),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserReplying = !_isUserReplying;
                              });
                            },
                            child: Text(
                              "Reply",
                              style:
                                  TextStyle(color: darkGreyColor, fontSize: 12),
                            )),
                        sizeHor(15),
                        GestureDetector(
                          onTap: () {
                            widget.comment.totalReplys == 0
                                ? toast("no replys")
                                : BlocProvider.of<ReplyCubit>(context)
                                    .getReplys(
                                        reply: ReplyEntity(
                                            postId: widget.comment.postId,
                                            commentId:
                                                widget.comment.commentId));
                          },
                          child: Text(
                            "View Replys",
                            style:
                                TextStyle(color: darkGreyColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ReplyCubit, ReplyState>(
                      builder: (context, replyState) {
                        if (replyState is ReplyLoaded) {
                          final replys = replyState.replys
                              .where((element) =>
                                  element.commentId == widget.comment.commentId)
                              .toList();
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: replys.length,
                              itemBuilder: (context, index) {
                                return SingleReplyWidget(
                                  reply: replys[index],
                                  onLongPressListener: () {
                                    _openBottomModalSheet(
                                        context: context, reply: replys[index]);
                                  },
                                  onLikeClickListener: () {
                                    _likeReply(reply: replys[index]);
                                  },
                                );
                              });
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    _isUserReplying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FormContainerWidget(
                                  hintText: "Post your reply...",
                                  controller: _replyDescriptionController),
                              sizeVer(10),
                              GestureDetector(
                                onTap: () {
                                  _createReply();
                                },
                                child: Text(
                                  "Post",
                                  style: TextStyle(color: blueColor),
                                ),
                              )
                            ],
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
            reply: ReplyEntity(
      replyId: Uuid().v1(),
      createAt: Timestamp.now(),
      likes: [],
      username: widget.currentUser!.username,
      userProfileUrl: widget.currentUser!.profileUrl,
      creatorUid: widget.currentUser!.uid,
      postId: widget.comment.postId,
      commentId: widget.comment.commentId,
      description: _replyDescriptionController.text,
    ))
        .then((value) {
      setState(() {
        _replyDescriptionController.clear();
        _isUserReplying = false;
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required ReplyEntity reply}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: backgroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteReply(reply: reply);
                        },
                        child: Text(
                          "Delete Reply",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                    Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    sizeVer(7),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageConst.updateReplyPage,
                              arguments: reply);

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                        },
                        child: Text(
                          "Update Reply",
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

  _deleteReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }
}
