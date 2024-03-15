class InvoiceEntity {
  final String id;
  final String? description;
  final int? userId;
  final String categoryId;
  final DateTime createdAt;
  final String? attachmentUrl;

  InvoiceEntity({
    required this.id,
    required this.description,
    this.userId,
    required this.categoryId,
    required this.createdAt,
    this.attachmentUrl,
  });
}
