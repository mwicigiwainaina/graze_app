import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/repository/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository repository;

  CreateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.createReply(reply);
  }
}
