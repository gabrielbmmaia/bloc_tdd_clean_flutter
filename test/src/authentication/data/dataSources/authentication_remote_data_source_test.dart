import 'dart:convert';

import 'package:bloc_tdd_clean_flutter/core/errors/exceptions.dart';
import 'package:bloc_tdd_clean_flutter/core/utils/constants.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/dataSources/authentication_remote_data_source.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      /* arrange estamos apenas falando que qualquer chamada de qualquer Uri e
      * qualquer body responderemos com
      * http.Response ('user created successfully', 201)*/
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      // act neste teste vamos testar se essa funcionalidade teve sucesso
      final methodCall = remoteDataSource.createUser;

      /*
      * assert aqui estamos vendo se o nosso mock do http está recebendo um
      * post request
      * */
      expect(
        methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        completes,
      );
      verify(() => client.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar'
          }))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw [APIException] when the status coide is not 200 or 201',
        () {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('Invalid email adress', 400),
      );

      final methodCall = remoteDataSource.createUser;

      expect(
        () async => methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(const APIException(
            message: 'Invalid email address', statusCode: 400)),
      );

      verify(() => client.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar'
          }))).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];

    test('should return [List<User>] when status code is 200', () async {
      //arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );

      //act
      final result = await remoteDataSource.getUsers();

      // assert
      expect(result, equals(tUsers));
      verify(
        () => client.get(Uri.https(kBaseUrl, kGetUsersEndPoint)),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should return [APIException] when status code is not 200', () async {

      //arrange
      const tMessage = 'Server down';
      const tStatusCode = 500;
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response(tMessage, tStatusCode));

      // act
      final result = remoteDataSource.getUsers;

      // assert
      expect(
        () async => result(),
        throwsA(const APIException(message: tMessage, statusCode: tStatusCode)),
      );

      verify(() => client.get(Uri.https(kBaseUrl, kGetUsersEndPoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
