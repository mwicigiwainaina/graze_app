import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/repository/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository repository;

  DeleteReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.deleteReply(reply);
  }
}
