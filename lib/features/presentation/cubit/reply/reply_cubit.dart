import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/usecases/reply/create_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/delete_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/like_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/read_reply_usecase.dart';
import 'package:graze_app/features/domain/usecases/reply/update_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final ReadReplysUseCase readReplysUseCase;
  final UpdateReplyUseCase updateReplyUseCase;
  ReplyCubit(
      {required this.createReplyUseCase,
      required this.updateReplyUseCase,
      required this.readReplysUseCase,
      required this.likeReplyUseCase,
      required this.deleteReplyUseCase})
      : super(ReplyInitial());

  Future<void> getReplys({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = readReplysUseCase.call(reply);
      streamResponse.listen((replys) {
        emit(ReplyLoaded(replys: replys));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    try {
      await likeReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyEntity reply}) async {
    try {
      await createReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    try {
      await updateReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
