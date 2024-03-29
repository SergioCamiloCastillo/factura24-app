import 'dart:convert';
import 'package:factura24/features/invoice/infrastructure/datasources/local_storage/invoice_datasource_impl.dart';
import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';
import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowCategoriesProvider =
    StateNotifierProvider<CategoryInvoiceNotifier, CategoryInvoiceState>(
  (ref) {
    final fetchCategories =
        ref.watch(categoryInvoiceRepositoryProvider).getCategoriesInvoice;
    return CategoryInvoiceNotifier(
        fetchCategories: fetchCategories,
        keyValueStorageService: KeyValueStorageServiceImpl());
  },
);

typedef CategoryInvoiceCallback = Future<List<CategoryInvoiceEntity>>
    Function();

class CategoryInvoiceNotifier extends StateNotifier<CategoryInvoiceState> {
  CategoryInvoiceCallback fetchCategories;
  KeyValueStorageService keyValueStorageService = KeyValueStorageServiceImpl();

  CategoryInvoiceNotifier({
    required this.fetchCategories,
    required this.keyValueStorageService,
  }) : super(CategoryInvoiceState());

  Future<void> loadCategories() async {
    _loadCategoriesFromStorage();
  }

  Future<void> addCategory(CategoryInvoiceEntity newCategory) async {
    state = state.copyWith(categories: [...state.categories, newCategory]);
    await _saveCategoriesToStorage();
  }

  Future<void> deleteCategory(CategoryInvoiceEntity categoryToDelete) async {
    await Future.delayed(const Duration(
        milliseconds: 500)); // Esperar 1 segundo antes de ejecutar el código

    state = state.copyWith(
      categories: state.categories
          .where((category) => category.id != categoryToDelete.id)
          .toList(),
    );
    await _saveCategoriesToStorage();
  }

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

  Future<void> updateCategory(CategoryInvoiceEntity updatedCategory) async {
    state = state.copyWith(
      categories: state.categories.map((category) {
        return category.id == updatedCategory.id ? updatedCategory : category;
      }).toList(),
    );
  }

  Future<void> changeCategorySelected(String idCategorySelected) async {
    state = state.copyWith(selectedCategory: idCategorySelected);
  }

  Future<void> _loadCategoriesFromStorage() async {
    final encodedCategories =
        await keyValueStorageService.getKeyValue<String>('categories_invoice');
    if (encodedCategories != null) {
      final decodedCategories = jsonDecode(encodedCategories);
      if (decodedCategories is List) {
        List<CategoryInvoiceEntity> categories =
            List<CategoryInvoiceEntity>.from(decodedCategories
                .map((json) => CategoryInvoiceEntity.fromJson(json)));

        if (categories.isNotEmpty) {
          state = CategoryInvoiceState(
            categories: categories,
            selectedCategory: categories[0].id,
          );
        }
      }
    }
  }

  Future<void> _saveCategoriesToStorage() async {
    final encodedCategories = jsonEncode(
        state.categories.map((category) => category.toJson()).toList());
    await keyValueStorageService.setKeyValue(
      'categories_invoice',
      encodedCategories,
    );
  }
}

class CategoryInvoiceState {
  final List<CategoryInvoiceEntity> categories;
  final String selectedCategory;

  CategoryInvoiceState({
    this.categories = const [],
    this.selectedCategory = '',
  });

  CategoryInvoiceState copyWith({
    List<CategoryInvoiceEntity>? categories,
    String? selectedCategory,
  }) {
    return CategoryInvoiceState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
