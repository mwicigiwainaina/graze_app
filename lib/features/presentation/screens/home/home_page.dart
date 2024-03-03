import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:graze_app/features/presentation/screens/home/widgets/single_post_card_widget.dart';
import 'package:graze_app/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: SvgPicture.asset("assets/ic_instagram.svg", color: primaryColor, height: 32,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.border_outer_outlined, color: primaryColor,),
          )
        ],
      ),
      body: BlocProvider<PostCubit>(
        create: (context) =>
        di.sl<PostCubit>()
          ..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (postState is PostFailure) {
              toast("Some Failure occured while creating the post");
            }
            if (postState is PostLoaded) {
              return postState.posts.isEmpty? _noPostsYetWidget() : ListView.builder(
                itemCount: postState.posts.length,
                itemBuilder: (context, index) {
                  final post = postState.posts[index];
                  return BlocProvider(
                    create: (context) => di.sl<PostCubit>(),
                    child: SinglePostCardWidget(post: post),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

  _noPostsYetWidget() {
    return Center(child: Text("No Posts Yet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),);
  }
}
