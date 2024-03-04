import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:graze_app/features/presentation/screens/profile/widgets/single_user_profile_main_widget.dart';
import 'package:graze_app/injection_container.dart' as di;

class SingleUserProfilePage extends StatelessWidget {
  final String otherUserId;

  const SingleUserProfilePage({Key? key, required this.otherUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: SingleUserProfileMainWidget(otherUserId: otherUserId),
    );
  }
}
