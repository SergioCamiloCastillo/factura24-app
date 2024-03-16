class InvoiceEntity {
  final String id;
  final String? description;
  final int? userId;
  final String categoryId;
  final String createdAt;
  final String? attachmentUrl;

  InvoiceEntity({
    required this.id,
    required this.description,
    this.userId,
    required this.categoryId,
    required this.createdAt,
    this.attachmentUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'attachmentUrl': attachmentUrl,
    };
  }
   static InvoiceEntity fromMap(Map<String, dynamic> map) {
    return InvoiceEntity(
      id: map['id'],
      description: map['description'],
      userId: map['userId'],
      categoryId: map['categoryId'],
      createdAt: map['createdAt'],
      attachmentUrl: map['attachmentUrl'],
    );
  }
}
