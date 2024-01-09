import 'package:factura24/features/invoice/infrastructure/datasources/category_invoice_datasource.dart';
import 'package:factura24/features/invoice/infrastructure/repositories/categories_invoice_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryInvoiceProvider = Provider((ref) {
  return CategoryInvoiceImpl(datasource: CategoryInvoiceDatasource());
});
