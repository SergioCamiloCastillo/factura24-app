import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/domain/repositories/invoices_repository.dart';
import 'package:factura24/features/invoice/presentation/providers/categories_invoices_provider.dart';
import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// el invoicesProvider, provee el estado de abajo de manera global, junto con el notifier
final invoicesProvider =
    StateNotifierProvider<InvoicesNotifier, InvoicesState>((ref) {
  final invoicesRepository = ref.watch(invoiceRepositoryProvider);
  final categoryInvoiceState = ref.watch(nowCategoriesProvider);

  return InvoicesNotifier(
    invoicesRepository: invoicesRepository,
    categoryInvoiceState: categoryInvoiceState,
  );
});

//state notifier provider

class InvoicesNotifier extends StateNotifier<InvoicesState> {
  final InvoicesRepository invoicesRepository;
  final CategoryInvoiceState categoryInvoiceState;

  InvoicesNotifier({
    required this.invoicesRepository,
    required this.categoryInvoiceState,
  }) : super(InvoicesState()) {
    if (categoryInvoiceState.selectedCategory.isNotEmpty) {
      loadInvoicesById();
    }
  }

  Future loadInvoicesById() async {
    final selectedCategoryId = categoryInvoiceState.selectedCategory;
    final invoices =
        await invoicesRepository.getInvoicesByCategoryId(selectedCategoryId);
    state = state.copyWith(invoices: [...state.invoices, ...invoices]);
  }

  Future<void> deleteInvoiceById(String id) async {
    final result = await invoicesRepository.deleteInvoiceById(id);
    if (result) {
      state = state.copyWith(
          invoices:
              state.invoices.where((element) => element.id != id).toList());
    }
  }

  Future<bool> deleteInvoiceByCategoryId(String id) async {
    final result = await invoicesRepository.deleteInvoiceByCategoryId(id);
    if (result) {
      state = state.copyWith(
          invoices:
              state.invoices.where((element) => element.id != id).toList());
    }
    return result;
  }
}

class InvoicesState {
  final List<InvoiceEntity> invoices;

  InvoicesState({this.invoices = const []});
  InvoicesState copyWith({List<InvoiceEntity>? invoices}) =>
      InvoicesState(invoices: invoices ?? this.invoices);
}
