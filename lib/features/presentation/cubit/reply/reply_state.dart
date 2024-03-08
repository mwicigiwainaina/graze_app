part of 'reply_cubit.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();
}

class ReplyInitial extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoading extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoaded extends ReplyState {
  final List<ReplyEntity> replys;

  ReplyLoaded({required this.replys});

  @override
  List<Object> get props => [replys];
}

class ReplyFailure extends ReplyState {
  @override
  List<Object> get props => [];
}
