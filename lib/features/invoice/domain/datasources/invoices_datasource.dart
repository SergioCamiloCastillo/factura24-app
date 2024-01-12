import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoicesDatasource {
  Future<List<InvoiceEntity>> getAllInvoices();
  Future<List<InvoiceEntity>> getInvoicesByCategoryId(int categoryId);
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike);
  Future<InvoiceEntity> getInvoiceById(String id);
}
