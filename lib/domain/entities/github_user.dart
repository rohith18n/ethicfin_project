import 'package:equatable/equatable.dart';

class GithubUser extends Equatable {
  final int id;
  final String login;
  final String? name;
  final String avatarUrl;
  final String htmlUrl;
  final String? bio;
  final String? company;
  final String? blog;
  final String? location;
  final String? email;
  final String? twitterUsername;
  final int publicRepos;
  final int publicGists;
  final int followers;
  final int following;
  final DateTime? createdAt;
  final String type;
  final bool? hireable;

  const GithubUser({
    required this.id,
    required this.login,
    this.name,
    required this.avatarUrl,
    required this.htmlUrl,
    this.bio,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.twitterUsername,
    required this.publicRepos,
    required this.publicGists,
    required this.followers,
    required this.following,
    this.createdAt,
    this.type = 'User',
    this.hireable,
  });

  String get displayName => (name != null && name!.trim().isNotEmpty) ? name! : login;

  @override
  List<Object?> get props => [
        id,
        login,
        name,
        avatarUrl,
        htmlUrl,
        bio,
        company,
        blog,
        location,
        email,
        twitterUsername,
        publicRepos,
        publicGists,
        followers,
        following,
        createdAt,
        type,
        hireable,
      ];
}
