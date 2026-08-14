import 'package:equatable/equatable.dart';

class GithubRepo extends Equatable {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String htmlUrl;
  final int stargazersCount;
  final int forksCount;
  final int openIssuesCount;
  final int watchersCount;
  final String? language;
  final bool isFork;
  final bool isPrivate;
  final bool isArchived;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? pushedAt;
  final String? defaultBranch;
  final String? licenseName;
  final List<String> topics;

  const GithubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.openIssuesCount,
    required this.watchersCount,
    this.language,
    this.isFork = false,
    this.isPrivate = false,
    this.isArchived = false,
    this.updatedAt,
    this.createdAt,
    this.pushedAt,
    this.defaultBranch,
    this.licenseName,
    this.topics = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fullName,
        description,
        htmlUrl,
        stargazersCount,
        forksCount,
        openIssuesCount,
        watchersCount,
        language,
        isFork,
        isPrivate,
        isArchived,
        updatedAt,
        createdAt,
        pushedAt,
        defaultBranch,
        licenseName,
        topics,
      ];
}
