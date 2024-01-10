//el objetivo de este provider es establecer a lo largo de toda la app, la instancia de InvoiceRespositoryImpl

import 'package:factura24/features/invoice/domain/repositories/categories_invoice_repository.dart';
import 'package:factura24/features/invoice/domain/repositories/invoices_repository.dart';
import 'package:factura24/features/invoice/infrastructure/datasources/category_invoice_datasource.dart';
import 'package:factura24/features/invoice/infrastructure/datasources/invoice_datasource.dart';
import 'package:factura24/features/invoice/infrastructure/repositories/categories_invoice_impl.dart';
import 'package:factura24/features/invoice/infrastructure/repositories/invoice_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryInvoiceRepositoryProvider = Provider<CategoriesInvoiceRepository>((ref) {
  return CategoryInvoiceImpl(datasource: CategoryInvoiceDatasource());
});

final invoiceRepositoryProvider = Provider<InvoicesRepository>((ref) {
  return InvoiceRepositoryImpl(datasource: InvoiceDatasourceImpl());
});
