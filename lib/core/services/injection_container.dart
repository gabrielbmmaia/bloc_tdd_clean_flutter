import 'package:bloc_tdd_clean_flutter/src/authentication/data/dataSources/authentication_remote_data_source.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/create_user.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/domain/usecases/get_users.dart';
import 'package:bloc_tdd_clean_flutter/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App Logic
    ..registerFactory(
        () => AuthenticationBloc(createUser: sl(), getUsers: sl()))

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(sl()))

    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()))

    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
