import 'package:bloc_tdd_clean_flutter/core/errors/exceptions.dart';
import 'package:bloc_tdd_clean_flutter/core/errors/failure.dart';
import 'package:bloc_tdd_clean_flutter/core/utils/typedef.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/dataSources/authentication_remote_data_source.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repository = AuthenticationRepositoryImpl(remoteDataSource);
  });

  const tException = APIException(
    message: 'Unknown Error Ocurred',
    statusCode: 500,
  );

  group('createUser', () {
    test(
      'should call [RemoteDataSource.createUser] and complete'
      ' successfully when the call to the remote source is successful',
      () async {
        // arrange
        when(
          () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')),
        ).thenAnswer((_) async => Future.value());

        const createdAt = 'createdAt';
        const name = 'name';
        const avatar = 'avatar';

        // act
        final result = await repository.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // assert
        expect(result, const Right(null));
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
        'should return a [ServerFailure] when the call to the remote'
        ' source is unsuccessful', () async {
      // arrenge
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenThrow(tException);

      const createdAt = 'createdAt';
      const name = 'name';
      const avatar = 'avatar';

      // act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // assert

      expect(
          result,
          equals(Left(APIFailure(
            message: tException.message,
            statusCode: tException.statusCode,
          ))));

      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
      'should call [RemoteDataSource.getUsers] and return [List<User>] when'
      ' call to remote source is successful',
      () async {
        // arrenge
        when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

        // act
        final result = await repository.getUsers();

        // Assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
        'shold call [RemoteDataSource.getUsers] and return [APIFailure] when'
        ' call to remote source is failure', () async {
      // arrenge
      when(
        () => remoteDataSource.getUsers(),
      ).thenThrow(tException);

      // act
      final result = await repository.getUsers();

      // assert
      expect(result, equals(Left(APIFailure.fromException(tException))));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
