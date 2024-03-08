import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/features/domain/entities/comment/comment_entity.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:graze_app/features/presentation/screens/posts/comment/widget/edit_reply_main_widget.dart';
import 'package:graze_app/injection_container.dart' as di;

class EditReplyPage extends StatelessWidget {
  final ReplyEntity reply;

  const EditReplyPage({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplyCubit>(
      create: (context) => di.sl<ReplyCubit>(),
      child: EditReplyMainWidget(reply: reply),
    );
  }
}
