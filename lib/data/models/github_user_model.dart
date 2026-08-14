import '../../domain/entities/github_user.dart';

class GithubUserModel extends GithubUser {
  const GithubUserModel({
    required super.id,
    required super.login,
    super.name,
    required super.avatarUrl,
    required super.htmlUrl,
    super.bio,
    super.company,
    super.blog,
    super.location,
    super.email,
    super.twitterUsername,
    required super.publicRepos,
    required super.publicGists,
    required super.followers,
    required super.following,
    super.createdAt,
    super.type = 'User',
    super.hireable,
  });

  factory GithubUserModel.fromJson(Map<String, dynamic> json) {
    return GithubUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      login: json['login']?.toString() ?? '',
      name: json['name']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? '',
      htmlUrl: json['html_url']?.toString() ?? '',
      bio: json['bio']?.toString(),
      company: json['company']?.toString(),
      blog: json['blog']?.toString(),
      location: json['location']?.toString(),
      email: json['email']?.toString(),
      twitterUsername: json['twitter_username']?.toString(),
      publicRepos: json['public_repos'] is int
          ? json['public_repos'] as int
          : int.tryParse(json['public_repos']?.toString() ?? '0') ?? 0,
      publicGists: json['public_gists'] is int
          ? json['public_gists'] as int
          : int.tryParse(json['public_gists']?.toString() ?? '0') ?? 0,
      followers: json['followers'] is int
          ? json['followers'] as int
          : int.tryParse(json['followers']?.toString() ?? '0') ?? 0,
      following: json['following'] is int
          ? json['following'] as int
          : int.tryParse(json['following']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      type: json['type']?.toString() ?? 'User',
      hireable: json['hireable'] is bool ? json['hireable'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'name': name,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'bio': bio,
      'company': company,
      'blog': blog,
      'location': location,
      'email': email,
      'twitter_username': twitterUsername,
      'public_repos': publicRepos,
      'public_gists': publicGists,
      'followers': followers,
      'following': following,
      'created_at': createdAt?.toIso8601String(),
      'type': type,
      'hireable': hireable,
    };
  }
}
