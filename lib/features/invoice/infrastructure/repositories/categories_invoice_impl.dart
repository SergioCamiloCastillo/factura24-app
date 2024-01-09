import 'package:factura24/features/invoice/domain/datasources/categories_invoice_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/invoice/domain/repositories/categories_invoice_repository.dart';

class CategoryInvoiceImpl extends CategoriesInvoiceRepository {
  final CategoriesInvoiceDataSource datasource;

  CategoryInvoiceImpl({required this.datasource});

  @override
  Future<List<CategoryInvoiceEntity>> getCategoriesInvoice() {
    return datasource.getCategoriesInvoice();
  }
}
