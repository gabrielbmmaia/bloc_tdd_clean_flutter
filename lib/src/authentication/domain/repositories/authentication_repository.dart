import 'package:bloc_tdd_clean_flutter/core/utils/typedef.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  /*
  * ResultVoid e ResultFuture são tipos de retorno abreviados
  * definidos em .../core/utils/typedef
  * */

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
