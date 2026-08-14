import '../../domain/entities/github_repo.dart';

class GithubRepoModel extends GithubRepo {
  const GithubRepoModel({
    required super.id,
    required super.name,
    required super.fullName,
    super.description,
    required super.htmlUrl,
    required super.stargazersCount,
    required super.forksCount,
    required super.openIssuesCount,
    required super.watchersCount,
    super.language,
    super.isFork = false,
    super.isPrivate = false,
    super.isArchived = false,
    super.updatedAt,
    super.createdAt,
    super.pushedAt,
    super.defaultBranch,
    super.licenseName,
    super.topics = const [],
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTopics = [];
    if (json['topics'] is List) {
      parsedTopics = (json['topics'] as List).map((e) => e.toString()).toList();
    }

    String? parsedLicense;
    if (json['license'] is Map) {
      final licenseMap = json['license'] as Map<String, dynamic>;
      parsedLicense = licenseMap['spdx_id']?.toString() ?? licenseMap['name']?.toString();
    }

    return GithubRepoModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      htmlUrl: json['html_url']?.toString() ?? '',
      stargazersCount: json['stargazers_count'] is int
          ? json['stargazers_count'] as int
          : int.tryParse(json['stargazers_count']?.toString() ?? '0') ?? 0,
      forksCount: json['forks_count'] is int
          ? json['forks_count'] as int
          : int.tryParse(json['forks_count']?.toString() ?? '0') ?? 0,
      openIssuesCount: json['open_issues_count'] is int
          ? json['open_issues_count'] as int
          : int.tryParse(json['open_issues_count']?.toString() ?? '0') ?? 0,
      watchersCount: json['watchers_count'] is int
          ? json['watchers_count'] as int
          : int.tryParse(json['watchers_count']?.toString() ?? '0') ?? 0,
      language: json['language']?.toString(),
      isFork: json['fork'] is bool ? json['fork'] as bool : false,
      isPrivate: json['private'] is bool ? json['private'] as bool : false,
      isArchived: json['archived'] is bool ? json['archived'] as bool : false,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      pushedAt: json['pushed_at'] != null ? DateTime.tryParse(json['pushed_at'].toString()) : null,
      defaultBranch: json['default_branch']?.toString(),
      licenseName: parsedLicense,
      topics: parsedTopics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'html_url': htmlUrl,
      'stargazers_count': stargazersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'watchers_count': watchersCount,
      'language': language,
      'fork': isFork,
      'private': isPrivate,
      'archived': isArchived,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'pushed_at': pushedAt?.toIso8601String(),
      'default_branch': defaultBranch,
      'license': licenseName != null ? {'spdx_id': licenseName} : null,
      'topics': topics,
    };
  }
}
