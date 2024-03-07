import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graze_app/core/constants/constants.dart';
import 'package:graze_app/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:graze_app/features/presentation/screens/activity/activity_screen.dart';
import 'package:graze_app/features/presentation/screens/home/home_page.dart';
import 'package:graze_app/features/presentation/screens/posts/upload_post_page.dart';
import 'package:graze_app/features/presentation/screens/profile/profile_page.dart';
import 'package:graze_app/features/presentation/screens/search/search_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;

  const MainScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            backgroundColor: backgroundColor,
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: backgroundColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home, color: primaryColor), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.search, color: primaryColor), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.favorite, color: primaryColor), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: primaryColor), label: ""),

              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                HomePage(),
                SearchPage(),
                UploadPostPage(currentUser: currentUser),
                ActivityPage(),
                ProfilePage(currentUser: currentUser,)
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
