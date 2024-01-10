import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';

class InvoiceMapper {
  static jsonToEntity(Map<String, dynamic> json) {
    return InvoiceEntity(
        id: json['id'],
        description: json['description'],
        userId: json['userId'],
        categoryId: json['categoryId'],
        createdAt: json['createdAt'],
        attachmentUrl: json['attachmentUrl']);
  }
}
