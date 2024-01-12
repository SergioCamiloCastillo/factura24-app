import 'dart:convert';

import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';

import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowCategoriesProvider =
    StateNotifierProvider<CategoryInvoiceNotifier, List<CategoryInvoiceEntity>>(
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

class CategoryInvoiceNotifier
    extends StateNotifier<List<CategoryInvoiceEntity>> {
  CategoryInvoiceCallback fetchCategories;
  KeyValueStorageService keyValueStorageService = KeyValueStorageServiceImpl();
  CategoryInvoiceNotifier(
      {required this.fetchCategories, required this.keyValueStorageService})
      : super([]);

  Future<void> loadCategories() async {
    final categories = await fetchCategories();

    _loadCategoriesFromStorage();
  }

  Future<void> addCategory(CategoryInvoiceEntity newCategory) async {
    state = [...state, newCategory];
    await _saveCategoriesToStorage();
  }

  Future<void> deleteCategory(CategoryInvoiceEntity categoryToDelete) async {
    state =
        state.where((category) => category.id != categoryToDelete.id).toList();
    await _saveCategoriesToStorage();
  }

  Future<void> updateCategory(CategoryInvoiceEntity updatedCategory) async {
    state = state.map((category) {
      if (category.id == updatedCategory.id) {
        return updatedCategory;
      }
      return category;
    }).toList();
  }

  Future<void> _loadCategoriesFromStorage() async {
    final encodedCategories =
        await keyValueStorageService.getKeyValue<String>('categories_invoice');
    if (encodedCategories != null) {
      final decodedCategories = jsonDecode(encodedCategories);
      if (decodedCategories is List) {
        state = List<CategoryInvoiceEntity>.from(decodedCategories
            .map((json) => CategoryInvoiceEntity.fromJson(json))).toList();
      }
    }
  }

  bool _containsMap(
      Map<String, dynamic> category, List<Map<String, dynamic>> categoryList) {
    return categoryList.any((element) => element['id'] == category['id']);
  }

  // Método auxiliar para guardar la lista de categorías en SharedPreferences
  Future<void> _saveCategoriesToStorage() async {
    final encodedCategories =
        jsonEncode(state.map((category) => category.toJson()).toList());
    await keyValueStorageService.setKeyValue(
        'categories_invoice', encodedCategories);
  }
}
