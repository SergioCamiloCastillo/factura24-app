import 'package:factura24/features/invoice/domain/datasources/categories_invoice_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/invoice/infrastructure/mapper/category_invoice_mapper.dart';

class CategoryInvoiceDatasource extends CategoriesInvoiceDataSource {
  @override
  Future<List<CategoryInvoiceEntity>> getCategoriesInvoice() async {
    List<Map<String, dynamic>> apiResponse = [];
    List<CategoryInvoiceEntity> categories = apiResponse.map((category) {
      return CategoryInvoiceMapper.categoryInvoiceToEntity(category);
    }).toList();
    return categories;
  }
}
