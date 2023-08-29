/*
* Perguntas inciais sobre um teste:
* 1-) Do que a classe depende para funcionar?
* R> AuthenticationRepository
* 2-) Como podemos criar uma versão fake desta dependência?
* R> Usando Mocktail ou Mockito
* 3-) Como controlamos oque nossa dependência faz?
* R> Usando Mocktail Api
* */

import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/create_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser useCase;
  late MockAuthRepo repository;

  const params = CreateUserParams.empty();

  setUp(() {
    repository = MockAuthRepo();
    useCase = CreateUser(repository);
  });

  test(
    'should call the [AuthRepo.createUser]',
    () async {
      /*
    * Arrange -> Tudo que precisamos antes de agirmos
    *
    * O parâmetro any() utiliza qualquer valor válido para aquele tipo.
    *
    * thenAnswer é usando quando o retorno na função é do tipo Future, caso
    * contrário é utilizado o thenReturn
    *
    * a resposta da função é Right porque o tipo de de retorno é um Either
    * e queremos testar caso a função seja um sucesso. Quando o retorno é um void
    * colocamos como null.
    *
    * */
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act -> Usar oque queremos testar

      final result = await useCase(params);

      // Assert -> Oque esperamos da nossa ação

      /*
    * Assert -> Oque esperamos da nossa ação
    *
    * em equals colocamos o retorno esperado e em seu Generic por ser um Either
    * colocamos o tipo do retorno que queremos e do lado contrário colocamos
    * dynamic porque não queremos importar uma classe que não iremos usar.
    * Ex: Left<ApiFailure, dynamic>  <- aqui queremos testar quando da errado.
    *
    * Aqui estamos checando o resultado final do useCase
    * */
      expect(result, equals(const Right<dynamic, void>(null)));
      /*
    * Agora precisamos checar se o useCase realmente chamou o repository e neste
    * caso queremos checar se houve apenas uma chamada e não inúmeras.
    * */
      verify(
        () => repository.createUser(
            createdAt: params.createdAt,
            name: params.name,
            avatar: params.avatar),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
