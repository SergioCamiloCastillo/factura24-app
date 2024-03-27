import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoicesRepository {
  Future<List<InvoiceEntity>> getAllInvoices();
  Future<List<InvoiceEntity>> getInvoicesByCategoryId(String categoryId);
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike);
  Future<InvoiceEntity> getInvoiceById(String id);
  Future<bool> deleteInvoiceByCategoryId(String id);
  Future<bool> deleteInvoiceById(String id);
}
