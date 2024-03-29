import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:graze_app/features/presentation/screens/profile/widgets/profile_form_widget.dart';
import 'package:graze_app/features/presentation/widgets/button_container_widget.dart';

class EditReplyMainWidget extends StatefulWidget {
  final ReplyEntity reply;
  const EditReplyMainWidget({Key? key, required this.reply}) : super(key: key);

  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {
  TextEditingController? _descriptionController;

  bool _isReplyUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Edit Reply"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "description",
              controller: _descriptionController,
            ),
            sizeVer(10),
            ButtonContainerWidget(
              color: blueColor,
              text: "Save Changes",
              onTapListener: () {
                _editReply();
              },
            ),
            sizeVer(10),
            _isReplyUpdating == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Updating...",
                        style: TextStyle(color: Colors.white),
                      ),
                      sizeHor(10),
                      CircularProgressIndicator(),
                    ],
                  )
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  _editReply() {
    setState(() {
      _isReplyUpdating = true;
    });
    BlocProvider.of<ReplyCubit>(context)
        .updateReply(
            reply: ReplyEntity(
                postId: widget.reply.postId,
                commentId: widget.reply.commentId,
                replyId: widget.reply.replyId,
                description: _descriptionController!.text))
        .then((value) {
      setState(() {
        _isReplyUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}
