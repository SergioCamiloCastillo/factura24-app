import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';

abstract class CategoriesInvoiceDataSource {
  Future<List<CategoryInvoiceEntity>> getCategoriesInvoice();
}
