class InvoiceEntity {
  final String id;
  final String description;
  final int userId;
  final int categoryId;
  final String createdAt;
  final String? attachmentUrl;

  InvoiceEntity({
    required this.id,
    required this.description,
    required this.userId,
    required this.categoryId,
    required this.createdAt,
    this.attachmentUrl,
  });
}
