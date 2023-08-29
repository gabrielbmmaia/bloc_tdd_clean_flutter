import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  const User.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  /*
   * Essa funcionalidade vem do Equatable e serve para comparar se as classes
   * são iguais apartir do valor que colocamos. Ex:. [id]
   * */
  @override
  List<Object?> get props => [id];
}
