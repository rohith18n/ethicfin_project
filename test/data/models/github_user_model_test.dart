import 'package:flutter_test/flutter_test.dart';
import 'package:ethicfin_project/data/models/github_user_model.dart';
import 'package:ethicfin_project/domain/entities/github_user.dart';

void main() {
  const tUserJson = {
    'id': 583231,
    'login': 'octocat',
    'name': 'The Octocat',
    'avatar_url': 'https://avatars.githubusercontent.com/u/583231?v=4',
    'html_url': 'https://github.com/octocat',
    'bio': 'GitHub mascot developer',
    'company': '@github',
    'blog': 'https://github.blog',
    'location': 'San Francisco',
    'email': 'octocat@github.com',
    'twitter_username': 'monatheoctocat',
    'public_repos': 8,
    'public_gists': 8,
    'followers': 9000,
    'following': 9,
    'created_at': '2011-01-25T18:44:36Z',
    'type': 'User',
    'hireable': true,
  };

  group('GithubUserModel', () {
    test('should be a subclass of GithubUser entity', () {
      final user = GithubUserModel.fromJson(tUserJson);
      expect(user, isA<GithubUser>());
    });

    test('should correctly parse all JSON fields into model', () {
      final user = GithubUserModel.fromJson(tUserJson);

      expect(user.id, 583231);
      expect(user.login, 'octocat');
      expect(user.name, 'The Octocat');
      expect(user.displayName, 'The Octocat');
      expect(user.avatarUrl, 'https://avatars.githubusercontent.com/u/583231?v=4');
      expect(user.htmlUrl, 'https://github.com/octocat');
      expect(user.bio, 'GitHub mascot developer');
      expect(user.company, '@github');
      expect(user.blog, 'https://github.blog');
      expect(user.location, 'San Francisco');
      expect(user.email, 'octocat@github.com');
      expect(user.twitterUsername, 'monatheoctocat');
      expect(user.publicRepos, 8);
      expect(user.publicGists, 8);
      expect(user.followers, 9000);
      expect(user.following, 9);
      expect(user.type, 'User');
      expect(user.hireable, true);
      expect(user.createdAt, DateTime.parse('2011-01-25T18:44:36Z'));
    });

    test('should handle null/missing optional fields safely', () {
      final minimalJson = {
        'id': 12345,
        'login': 'minimaluser',
        'avatar_url': 'https://example.com/avatar.png',
        'html_url': 'https://github.com/minimaluser',
        'public_repos': 0,
        'public_gists': 0,
        'followers': 0,
        'following': 0,
      };

      final user = GithubUserModel.fromJson(minimalJson);

      expect(user.id, 12345);
      expect(user.login, 'minimaluser');
      expect(user.name, isNull);
      expect(user.displayName, 'minimaluser');
      expect(user.bio, isNull);
      expect(user.hireable, isNull);
      expect(user.createdAt, isNull);
    });

    test('should correctly serialize to JSON map', () {
      final user = GithubUserModel.fromJson(tUserJson);
      final jsonMap = user.toJson();

      expect(jsonMap['login'], 'octocat');
      expect(jsonMap['public_repos'], 8);
      expect(jsonMap['followers'], 9000);
    });
  });
}
