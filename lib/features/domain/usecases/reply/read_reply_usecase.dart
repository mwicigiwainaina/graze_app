import 'package:graze_app/features/domain/entities/reply/reply_entity.dart';
import 'package:graze_app/features/domain/repository/firebase_repository.dart';

class ReadReplysUseCase {
  final FirebaseRepository repository;

  ReadReplysUseCase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repository.readReplys(reply);
  }
}
