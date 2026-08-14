import 'package:flutter_test/flutter_test.dart';
import 'package:ethicfin_project/data/models/github_repo_model.dart';
import 'package:ethicfin_project/domain/entities/github_repo.dart';

void main() {
  const tRepoJson = {
    'id': 1296269,
    'name': 'Hello-World',
    'full_name': 'octocat/Hello-World',
    'description': 'This your first repo!',
    'html_url': 'https://github.com/octocat/Hello-World',
    'stargazers_count': 1500,
    'forks_count': 500,
    'open_issues_count': 12,
    'watchers_count': 1500,
    'language': 'Dart',
    'fork': false,
    'private': false,
    'archived': false,
    'updated_at': '2024-05-01T12:00:00Z',
    'created_at': '2011-01-26T19:01:12Z',
    'pushed_at': '2024-05-01T12:00:00Z',
    'default_branch': 'master',
    'license': {
      'key': 'mit',
      'name': 'MIT License',
      'spdx_id': 'MIT',
    },
    'topics': ['flutter', 'dart', 'github-api'],
  };

  group('GithubRepoModel', () {
    test('should be a subclass of GithubRepo entity', () {
      final repo = GithubRepoModel.fromJson(tRepoJson);
      expect(repo, isA<GithubRepo>());
    });

    test('should correctly parse all JSON fields', () {
      final repo = GithubRepoModel.fromJson(tRepoJson);

      expect(repo.id, 1296269);
      expect(repo.name, 'Hello-World');
      expect(repo.fullName, 'octocat/Hello-World');
      expect(repo.description, 'This your first repo!');
      expect(repo.htmlUrl, 'https://github.com/octocat/Hello-World');
      expect(repo.stargazersCount, 1500);
      expect(repo.forksCount, 500);
      expect(repo.openIssuesCount, 12);
      expect(repo.watchersCount, 1500);
      expect(repo.language, 'Dart');
      expect(repo.isFork, false);
      expect(repo.isPrivate, false);
      expect(repo.isArchived, false);
      expect(repo.licenseName, 'MIT');
      expect(repo.topics, ['flutter', 'dart', 'github-api']);
      expect(repo.updatedAt, DateTime.parse('2024-05-01T12:00:00Z'));
    });

    test('should handle missing license and topics gracefully', () {
      final minimalJson = {
        'id': 999,
        'name': 'Minimal-Repo',
        'html_url': 'https://github.com/test/repo',
        'stargazers_count': 0,
        'forks_count': 0,
        'open_issues_count': 0,
        'watchers_count': 0,
      };

      final repo = GithubRepoModel.fromJson(minimalJson);

      expect(repo.name, 'Minimal-Repo');
      expect(repo.licenseName, isNull);
      expect(repo.topics, isEmpty);
      expect(repo.language, isNull);
    });
  });
}
