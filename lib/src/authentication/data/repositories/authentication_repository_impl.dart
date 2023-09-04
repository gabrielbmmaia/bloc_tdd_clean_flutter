import 'package:bloc_tdd_clean_flutter/core/errors/exceptions.dart';
import 'package:bloc_tdd_clean_flutter/core/errors/failure.dart';
import 'package:bloc_tdd_clean_flutter/core/utils/typedef.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/dataSources/authentication_remote_data_source.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/entities/user.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
