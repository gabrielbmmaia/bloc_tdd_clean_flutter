import 'package:bloc_tdd_clean_flutter/src/authentication/domain/entities/user.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers useCase;

  setUp(() {
    useCase = GetUsers(repository);
    repository = MockAuthRepo();
  });

  const tResponse = [User.empty()];

  test(
    'should call the [AuthRepo.getUsers] and return [List<User>]',
    () async {
      // Arrange
      when(() => repository.getUsers()).thenAnswer(
        (_) async => const Right(tResponse),
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Right<dynamic, List<User>>(tResponse)));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
