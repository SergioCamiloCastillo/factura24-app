import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:factura24/features/invoice/domain/datasources/invoices_datasource.dart';
import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/infrastructure/errors/invoice_error.dart';
import 'package:factura24/features/invoice/infrastructure/mapper/invoice_mapper.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

class InvoiceDatasourceImpl extends InvoicesDatasource {
  late Database _database;
  @override
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'invoices_information.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE invoices_information(id TEXT PRIMARY KEY, categoryId TEXT, createdAt TEXT, description TEXT, attachmentUrl TEXT, userId INTEGER)",
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<InvoiceEntity>> getAllInvoices() {
    // TODO: implement getAllInvoices
    throw UnimplementedError();
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesByCategoryId(String categoryId) async {
    await _initDatabase();
    final List<Map<String, dynamic>> invoices = await _database.query(
        'invoices_information',
        where: 'categoryId = ?',
        whereArgs: [categoryId]);
    List<InvoiceEntity> invoiceEntities = [];
    for (var invoiceMap in invoices) {
      InvoiceEntity invoiceEntity = InvoiceEntity(
        id: invoiceMap['id'],
        categoryId: invoiceMap['categoryId'],
        createdAt: invoiceMap['createdAt'],
        description: invoiceMap['description'],
        attachmentUrl: invoiceMap['attachmentUrl'],
        userId: invoiceMap['userId'],
        // Añade otras propiedades si es necesario
      );
      invoiceEntities.add(invoiceEntity);
    }
    return invoiceEntities;
  }

  @override
  Future<InvoiceEntity> createInvoice(Map<String, dynamic> invoiceLike) async {
    await _initDatabase();
    final InvoiceEntity invoice = InvoiceMapper.jsonToEntity(invoiceLike);
    await _database.insert('invoices_information', invoice.toJson());
    return invoice;
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
      await _initDatabase();
      final rowsDeleted = await _database.delete(
        'invoices_information',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (rowsDeleted == 0) {
        throw InvoiceNotFoundError();
      }
      return true;
    } catch (e) {
      throw UnimplementedError('No se pudo eliminar la factura');
    }
  }
}
