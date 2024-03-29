import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:graze_app/features/data/data_sources/remote_data_sources.dart';
import 'package:graze_app/features/data/data_sources/remote_data_sources_impl.dart';
import 'package:graze_app/features/data/models/user/user_model.dart';
import 'package:graze_app/features/data/repository/firebase_repository_impl.dart';
import 'package:graze_app/features/domain/repository/firebase_repository.dart';
import 'package:graze_app/features/domain/usecases/comment/create_comment_usecase.dart';
import 'package:graze_app/features/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:graze_app/features/domain/usecases/comment/like_comment_usecase.dart';
import 'package:graze_app/features/domain/usecases/comment/read_comment_usecase.dart';
import 'package:graze_app/features/domain/usecases/comment/update_comment_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/create_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/delete_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/like_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/read_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/read_single_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/post/update_post_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/create_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/delete_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/like_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/read_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/update_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/create_user_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/follow_unfollow_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/get_single_other_user.dart';
import 'package:graze_app/features/domain/usecases/user/get_single_user_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/get_users_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/is_sign_in_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/sign_in_user_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/sign_out_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/sign_up_user_usecase.dart';
import 'package:graze_app/features/domain/usecases/user/update_user_usecase.dart';
import 'package:graze_app/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:graze_app/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:graze_app/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:graze_app/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:graze_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:graze_app/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/get_single_other_user.dart/get_single_other_user_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:graze_app/features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signUpUserUseCase: sl.call(),
      signInUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(
        updateUserUseCase: sl.call(),
        getUsersUseCase: sl.call(),
        followUnFollowUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()),
  );

  // Post Cubit Injection
  sl.registerFactory(
    () => PostCubit(
        createPostUseCase: sl.call(),
        deletePostUseCase: sl.call(),
        likePostUseCase: sl.call(),
        readPostUseCase: sl.call(),
        updatePostUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSinglePostCubit(readSinglePostUseCase: sl.call()),
  );

  // Comment Cubit Injection
  sl.registerFactory(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
    ),
  );

  // Reply Cubit Injection
  sl.registerFactory(
    () => ReplyCubit(
        createReplyUseCase: sl.call(),
        deleteReplyUseCase: sl.call(),
        likeReplyUseCase: sl.call(),
        readReplysUseCase: sl.call(),
        updateReplyUseCase: sl.call()),
  );

  // Use Cases
  // User
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => FollowUnFollowUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleOtherUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Reply
  sl.registerLazySingleton(() => CreateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
