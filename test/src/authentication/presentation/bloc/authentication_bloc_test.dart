import 'package:bloc_tdd_clean_flutter/core/errors/failure.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/models/user_model.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/create_user.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/get_users.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationBloc bloc;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    bloc = AuthenticationBloc(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  // Funcionalidade para ser executada depois de cada teste
  // Neste caso, estamos recriando a instancia do bloc em cada teste
  tearDown(() => bloc.close());

  // Neste teste não precisao de arrange ou act porque o bloc já está instancializado
  // então só precisamos checar se o estado inicial está correto
  test('initial state should be [AuthenticationInitial]', () async {
    expect(bloc.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateUserEvent(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      )),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [CreatingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tAPIFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateUserEvent(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      )),
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    const tUserList = [UserModel.empty()];

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [GettingUsers, UserLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right(tUserList));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUsersEvent()),
      expect: () => const [GettingUsers(), UsersLoad(tUserList)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUsersEvent()),
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
