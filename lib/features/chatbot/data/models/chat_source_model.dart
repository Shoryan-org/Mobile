import '../../domain/entities/chat_source_entity.dart';

class ChatSourceModel extends ChatSourceEntity {
  const ChatSourceModel({
    required super.citationId,
    required super.sourceFile,
    required super.section,
    super.score,
    required super.docTitle,
    required super.category,
    required super.lastVerified,
    required super.officialSources,
  });

  factory ChatSourceModel.fromJson(Map<String, dynamic> json) {
    return ChatSourceModel(
      citationId: json['citation_id'] as int,
      sourceFile: json['source_file'] as String,
      section: json['section'] as String,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      docTitle: json['doc_title'] as String,
      category: json['category'] as String,
      lastVerified: json['last_verified'] as String,
      officialSources: json['official_sources'] as String,
    );
  }
}
