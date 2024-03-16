import 'package:factura24/features/invoice/domain/datasources/invoices_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/domain/repositories/invoices_repository.dart';

class InvoiceRepositoryImpl extends InvoicesRepository {
  final InvoicesDatasource datasource;

  InvoiceRepositoryImpl({required this.datasource});

  @override
  Future<List<InvoiceEntity>> getAllInvoices() async {
    return datasource.getAllInvoices();
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesByCategoryId(String categoryId) async {
    return datasource.getInvoicesByCategoryId(categoryId);
  }

  @override
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike) async {
    return datasource.createInvoice(invoiceLike);
  }
  
  @override
  Future<InvoiceEntity> getInvoiceById(String id) {
    return datasource.getInvoiceById(id);
  }
  
  @override
  Future<bool> deleteInvoiceByCategoryId(String id) {
    return datasource.deleteInvoiceByCategoryId(id);
  }
}
