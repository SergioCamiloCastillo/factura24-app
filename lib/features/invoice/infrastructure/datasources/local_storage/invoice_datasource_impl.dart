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
    final keyValueStorageService = KeyValueStorageServiceImpl();
    try {
      final encodedInvoices =
          await keyValueStorageService.getKeyValue<String>('invoices_data');
      List<dynamic> decodedInvoices = jsonDecode(encodedInvoices!) ?? [];
      List<InvoiceEntity> filteredInvoices = decodedInvoices
          .where((invoice) => invoice['categoryId'] == categoryId)
          .map<InvoiceEntity>((invoice) => InvoiceMapper.jsonToEntity(invoice))
          .toList();

      // Ordenar las facturas por fecha
      filteredInvoices.sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

      return filteredInvoices;
    } catch (e) {
      throw UnimplementedError(
          'No se pudieron obtener las facturas por categoría');
    }
  }

  @override
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike) async {
    print('llega aquiiii');
    final keyValueStorageService = KeyValueStorageServiceImpl();
    try {
      final encodedInvoices =
          await keyValueStorageService.getKeyValue<String>('invoices_data');

      print('hay 1');
      // Convertir el JSON a una lista de objetos InvoiceEntity
      List<dynamic> decodedInvoices = jsonDecode(encodedInvoices!) ?? [];
      print('hay 2');

      final invoice = InvoiceMapper.jsonToEntity(invoiceLike);
      decodedInvoices
          .add(invoice.toJson()); // Agregar el nuevo invoice a la lista

      // Codificar toda la lista de nuevo a JSON y guardarla en el almacenamiento
      keyValueStorageService.setKeyValue(
          'invoices_data', jsonEncode(decodedInvoices));
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

  @override
  Future<bool> deleteInvoiceByCategoryId(String id) async {
    try {
      final keyValueStorageService = KeyValueStorageServiceImpl();
      final encodedInvoicesFuture =
          keyValueStorageService.getKeyValue<String>('invoices_data');
      final encodedInvoices = await encodedInvoicesFuture;

      if (encodedInvoices == null) {
        throw Exception('No hay facturas almacenadas');
      }

      final List<dynamic> decodedInvoices = jsonDecode(encodedInvoices) ?? [];
      final updatedInvoices = decodedInvoices
          .where((invoice) => invoice['id'] != id)
          .toList(); // Eliminar la factura con el id especificado
      keyValueStorageService.setKeyValue(
          'invoices_data', jsonEncode(updatedInvoices));
      return true;
    } catch (e) {
      throw UnimplementedError('No se pudo eliminar la factura');
    }
  }
}
