import 'dart:convert';

import 'package:factura24/features/invoice/domain/datasources/invoices_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/infrastructure/errors/invoice_error.dart';
import 'package:factura24/features/invoice/infrastructure/mapper/invoice_mapper.dart';
import 'package:factura24/features/invoice/infrastructure/models/invoice/invoice_model.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

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
        "categoryId": '75be9ded34326125',
        "createdAt": "2021-09-01T00:00:00.000Z",
        "attachmentUrl": "https://factura24.com/factura1.pdf"
      },
      {
        "id": 'dijfeijfei',
        "description": "Factura 2",
        "userId": 1,
        "categoryId": '75be9ded34326125',
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
    print('llega aquiiii');
    final keyValueStorageService = KeyValueStorageServiceImpl();
    try {
      final encodedInvoices =
          keyValueStorageService.getKeyValue<String>('invoices_data');
      final decodedInvoices = jsonDecode(encodedInvoices as String);
      final invoice = InvoiceMapper.jsonToEntity(invoiceLike);
      final newInvoices = [...decodedInvoices, invoice];
      keyValueStorageService.setKeyValue(
          'invoices_data', jsonEncode(newInvoices));
      return invoice;
    } catch (e) {
      throw UnimplementedError('No se pudo crear la factura');
    }
  }

  @override
  Future<InvoiceEntity> getInvoiceById(String id) async {
    final keyValueStorageService = KeyValueStorageServiceImpl();
    try {
      print(
        'que contiene esto=>${await keyValueStorageService.getKeyValue<String>('invoices_data')}',
      );
      final encodedInvoices =
          await keyValueStorageService.getKeyValue<String>('invoices_data');

      final decodedInvoices = jsonDecode(encodedInvoices!);
      final invoice = decodedInvoices
          .firstWhere((invoice) => invoice['id'] == id, orElse: () => {})
          .map<InvoiceEntity>((invoice) => InvoiceMapper.jsonToEntity(invoice));
      if (!invoice) {
        throw InvoiceNotFoundError();
      }
      return invoice;
    } catch (e) {
      throw UnimplementedError('No se encontró la factura');
    }
  }
}
