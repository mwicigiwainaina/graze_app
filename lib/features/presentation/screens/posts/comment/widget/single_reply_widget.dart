import 'package:flutter/material.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:graze_app/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:graze_app/injection_container.dart' as di;

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget(
      {Key? key,
      required this.reply,
      this.onLongPressListener,
      this.onLikeClickListener})
      : super(key: key);

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.reply.userProfileUrl),
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
                          "${widget.reply.username}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.reply.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.reply.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : darkGreyColor,
                            ))
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.reply.description}",
                      style: TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    Text(
                      "${DateFormat("dd/MMM/yyy").format(widget.reply.createAt!.toDate())}",
                      style: TextStyle(color: darkGreyColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
