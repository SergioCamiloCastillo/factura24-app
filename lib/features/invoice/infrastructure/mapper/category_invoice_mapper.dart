import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';

class CategoryInvoiceMapper {
  static CategoryInvoiceEntity categoryInvoiceToEntity(
      Map<String, dynamic> json) {
    return CategoryInvoiceEntity(
      id: json['id'],
      title: json['title'],
      user: json['user'],
      color: json['color'],
    );
  }
}
