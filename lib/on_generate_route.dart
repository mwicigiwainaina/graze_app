import 'package:flutter/material.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/domain/entities/app_entity.dart';
import 'package:graze_app/features/domain/entities/comment/comment_entity.dart';
import 'package:graze_app/features/domain/entities/posts/post_entity.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/entities/user/user_entity.dart';
import 'package:graze_app/features/presentation/screens/auth/sign_in_page.dart';
import 'package:graze_app/features/presentation/screens/auth/sign_up_page.dart';
import 'package:graze_app/features/presentation/screens/posts/comment/comment_page.dart';
import 'package:graze_app/features/presentation/screens/posts/comment/edit_comment_page.dart';
import 'package:graze_app/features/presentation/screens/posts/comment/edit_reply_page.dart';
import 'package:graze_app/features/presentation/screens/posts/post_detail_page.dart';
import 'package:graze_app/features/presentation/screens/posts/update_post_page.dart';
import 'package:graze_app/features/presentation/screens/profile/edit_profile_page.dart';
import 'package:graze_app/features/presentation/screens/profile/followers_page.dart';
import 'package:graze_app/features/presentation/screens/profile/following_page.dart';
import 'package:graze_app/features/presentation/screens/profile/single_user_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(UpdatePostPage(
              post: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(EditCommentPage(
              comment: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateReplyPage:
        {
          if (args is ReplyEntity) {
            return routeBuilder(EditReplyPage(
              reply: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.commentPage:
        {
          if (args is AppEntity) {
            return routeBuilder(CommentPage(
              appEntity: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.postDetailPage:
        {
          if (args is String) {
            return routeBuilder(PostDetailPage(
              postId: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.singleUserProfilePage:
        {
          if (args is String) {
            return routeBuilder(SingleUserProfilePage(
              otherUserId: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.followingPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowingPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.followersPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowersPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.signInPage:
        {
          return routeBuilder(const SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      default:
        {
          const NoPageFound();
        }
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page not found"),
      ),
      body: const Center(
        child: const Text("Page not found"),
      ),
    );
  }
}
