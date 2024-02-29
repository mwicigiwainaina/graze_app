import 'package:graze_app/features/domain/entities/user/user_entity.dart';
import 'package:graze_app/features/domain/repository/firebase_repository.dart';

class SignUpUserUseCase {
  final FirebaseRepository repository;

  SignUpUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}