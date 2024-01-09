import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';

import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowCategoriesProvider =
    StateNotifierProvider<CategoryInvoiceNotifier, List<CategoryInvoiceEntity>>(
  (ref) {
    final fetchCategories =
        ref.watch(categoryInvoiceProvider).getCategoriesInvoice;
    return CategoryInvoiceNotifier(fetchCategories: fetchCategories);
  },
);

typedef CategoryInvoiceCallback = Future<List<CategoryInvoiceEntity>>
    Function();

class CategoryInvoiceNotifier
    extends StateNotifier<List<CategoryInvoiceEntity>> {
  CategoryInvoiceCallback fetchCategories;
  CategoryInvoiceNotifier({required this.fetchCategories}) : super([]);

  Future<void> loadCategories() async {
    final categories = await fetchCategories();
    state = [...state, ...categories];
  }

  Future<void> addCategory(CategoryInvoiceEntity newCategory) async {
    state = [...state, newCategory];
  }

  Future<void> deleteCategory(CategoryInvoiceEntity categoryToDelete) async {
    state =
        state.where((category) => category.id != categoryToDelete.id).toList();
  }

  Future<void> updateCategory(CategoryInvoiceEntity updatedCategory) async {
    state = state.map((category) {
      if (category.id == updatedCategory.id) {
        return updatedCategory;
      }
      return category;
    }).toList();
  }
}
