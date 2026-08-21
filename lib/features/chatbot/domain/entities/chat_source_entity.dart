class ChatSourceEntity {
  final int citationId;
  final String sourceFile;
  final String section;
  final double? score;
  final String docTitle;
  final String category;
  final String lastVerified;
  final String officialSources;

  const ChatSourceEntity({
    required this.citationId,
    required this.sourceFile,
    required this.section,
    this.score,
    required this.docTitle,
    required this.category,
    required this.lastVerified,
    required this.officialSources,
  });
}
