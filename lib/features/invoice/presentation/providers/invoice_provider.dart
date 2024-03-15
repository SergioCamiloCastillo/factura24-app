import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/domain/repositories/invoices_repository.dart';
import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final invoiceProvider = StateNotifierProvider.autoDispose
    .family<InvoiceNotifier, InvoiceState, Map<String, String>>(
  (ref, params) {
    final invoiceRepository = ref.watch(invoiceRepositoryProvider);
    final categoryId = params['categoryId']; // Obtener categoryId del parámetro
    return InvoiceNotifier(
      invoicesRepository: invoiceRepository,
      invoiceId: params['invoiceId']!,
      categoryId: categoryId!,
    );
  },
);

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final InvoicesRepository invoicesRepository;
  final String categoryId;
  InvoiceNotifier({
    required this.invoicesRepository,
    required String invoiceId,
    required this.categoryId, // Incluir categoryId en el constructor
  }) : super(InvoiceState(id: invoiceId)) {
    loadInvoice();
  }

  InvoiceEntity _newEmptyInvoice() {
    return InvoiceEntity(
        id: 'new',
        description: '',
        createdAt: DateTime.now(),
        userId: 1,
        categoryId: categoryId);
  }

  Future<void> loadInvoice() async {
    if (state.id == 'new') {
      state = state.copyWith(invoice: _newEmptyInvoice(), isLoading: false);
      return;
    }
    try {
      final invoice = await invoicesRepository.getInvoiceById(state.id);

      state = state.copyWith(isLoading: false, invoice: invoice);
    } catch (e) {
      print(e);
    }
  }
}

class InvoiceState {
  final String id;
  final InvoiceEntity? invoice;
  final bool isLoading;
  final bool isSaving;

  InvoiceState(
      {required this.id,
      this.invoice,
      this.isLoading = true,
      this.isSaving = false});

  InvoiceState copyWith(
      {String? id, InvoiceEntity? invoice, bool? isLoading, bool? isSaving}) {
    return InvoiceState(
        id: id ?? this.id,
        invoice: invoice ?? this.invoice,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving);
  }
}
