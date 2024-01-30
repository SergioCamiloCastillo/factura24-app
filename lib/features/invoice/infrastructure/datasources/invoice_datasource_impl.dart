import 'package:factura24/features/invoice/domain/datasources/invoices_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/infrastructure/mapper/invoice_mapper.dart';
import 'package:factura24/features/invoice/infrastructure/models/invoice/invoice_model.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';

class InvoiceDatasourceImpl extends InvoicesDatasource {
  @override
  Future<List<InvoiceEntity>> getAllInvoices() {
    // TODO: implement getAllInvoices
    throw UnimplementedError();
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesByCategoryId(String categoryId) async {
    print('si llega $categoryId');
    List invoicesResponse = [
      {
        "id": 'dijfeijfei',
        "description": "Factura 1",
        "userId": 1,
        "categoryId": '6578dc0e7c1305ec',
        "createdAt": "2021-09-01T00:00:00.000Z",
        "attachmentUrl": "https://factura24.com/factura1.pdf"
      },
      {
        "id": 'dijfeijfei',
        "description": "Factura 2",
        "userId": 1,
        "categoryId": '-686bf5861781daaf',
        "createdAt": "2021-09-01T00:00:00.000Z",
        "attachmentUrl": "https://factura24.com/factura1.pdf"
      }
    ];

    return invoicesResponse
        .where((invoice) => invoice['categoryId'] == categoryId)
        .map<InvoiceEntity>((invoice) => InvoiceMapper.jsonToEntity(invoice))
        .toList();
  }

  @override
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike) {
    // TODO: implement createInvoice
    throw UnimplementedError();
  }

  @override
  Future<InvoiceEntity> getInvoiceById(String id) async {
    return InvoiceMapper.jsonToEntity({
      "id": 'dijfeijfei',
      "description": "Factura 1",
      "userId": 1,
      "categoryId": 1,
      "createdAt": "2021-09-01T00:00:00.000Z",
      "attachmentUrl": "https://factura24.com/factura1.pdf"
    });
  }
}
