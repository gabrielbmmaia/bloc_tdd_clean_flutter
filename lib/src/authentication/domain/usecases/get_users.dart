import 'package:bloc_tdd_clean_flutter/core/usecase/usecase.dart';
import 'package:bloc_tdd_clean_flutter/core/utils/typedef.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/entities/user.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UseCaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
