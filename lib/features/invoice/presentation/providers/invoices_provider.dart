import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/domain/repositories/invoices_repository.dart';
import 'package:factura24/features/invoice/presentation/providers/categories_invoices_provider.dart';
import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// el invoicesProvider, provee el estado de abajo de manera global, junto con el notifier
final invoicesProvider =
    StateNotifierProvider<InvoicesNotifier, InvoicesState>((ref) {
  final invoicesRepository = ref.watch(invoiceRepositoryProvider);
  final categoryInvoiceState =
      ref.watch(nowCategoriesProvider); // Get CategoryInvoiceState

  return InvoicesNotifier(
      invoicesRepository: invoicesRepository,
      categoryInvoiceState: categoryInvoiceState);
});

//state notifier provider

class InvoicesNotifier extends StateNotifier<InvoicesState> {
  final InvoicesRepository invoicesRepository;
  final CategoryInvoiceState categoryInvoiceState;
  InvoicesNotifier({
    required this.invoicesRepository,
    required this.categoryInvoiceState,
  }) : super(InvoicesState()) {
    loadInvoices();
  }

  Future loadInvoices() async {
    final selectedCategoryId = categoryInvoiceState.selectedCategory;
    final invoices =
        await invoicesRepository.getInvoicesByCategoryId(selectedCategoryId);
    state = state.copyWith(invoices: [...state.invoices, ...invoices]);
  }
}

class InvoicesState {
  final List<InvoiceEntity> invoices;

  InvoicesState({this.invoices = const []});
  InvoicesState copyWith({List<InvoiceEntity>? invoices}) =>
      InvoicesState(invoices: invoices ?? this.invoices);
}
