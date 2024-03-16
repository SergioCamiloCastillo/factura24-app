import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/presentation/providers/invoice_repository_provider.dart';
import 'package:factura24/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

// final invoiceFormProvider = StateNotifierProvider.autoDispose
//     .family<InvoiceFormNotifier, InvoiceFormState, InvoiceEntity>(
//         (ref, invoice) {
//   //TODO: Createupdate callback
//   return InvoiceFormNotifier(invoice: invoice);
// });

final invoiceFormProvider =
    StateNotifierProvider.autoDispose<InvoiceFormNotifier, InvoiceFormState>(
        (ref) {
  final createUpdateCallback =
      ref.watch(invoiceRepositoryProvider).createInvoice;
  //TODO: Createupdate callback
  return InvoiceFormNotifier(onSubmitCallback: createUpdateCallback);
});

class InvoiceFormNotifier extends StateNotifier<InvoiceFormState> {
  final Future<InvoiceEntity> Function(Map<String, dynamic> invoiceLike)?
      onSubmitCallback;

  InvoiceFormNotifier({this.onSubmitCallback}) : super(InvoiceFormState());

  void onAttachmentUrlChanged(String attachmentUrl) {
    state = state.copyWith(attachmentUrl: attachmentUrl);
  }

  void onDescriptionChanged(String description) {
    print('descriptionnnnn=>$description');
    state = state.copyWith(description: description);
    print('el state esss=>${state.description}');
    //quitar idFormValid porque no es obligatorio
    //isFormValid: Formz.validate([Description.dirty(value)])
  }

  String generateUniqueId() {
    // Obtener la fecha y hora actual
    DateTime now = DateTime.now();

    // Crear un identificador único concatenando la fecha y hora actual con los segundos
    String uniqueId =
        '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';

    return uniqueId;
  }

  void updateInvocie(InvoiceEntity invoice) {
    state = state.copyWith(
        id: invoice.id,
        attachmentUrl: invoice.attachmentUrl,
        description: invoice.description ?? '');
  }

  Future<bool> onFormSubmit(categoryInvoiceId) async {
    _touchEveryThing();
    if (onSubmitCallback == null) return false;

    final invoiceLike = {
      'id': state.id == 'new' ? generateUniqueId() : generateUniqueId(),
      'description': state.description,
      'attachmentUrl': state.attachmentUrl,
      'categoryId': categoryInvoiceId,
      'userId': 1,
      'createdAt': DateTime.now().toIso8601String().toString(),
    };
    try {
      await onSubmitCallback!(invoiceLike);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _touchEveryThing() {
    state = state.copyWith();
  }

  void updateInvoiceImage(String path) {
    state = state.copyWith(attachmentUrl: path);
  }
}

class InvoiceFormState {
  final bool isFormValid;
  final String? id;
  final String description;
  final String? attachmentUrl;

  InvoiceFormState(
      {this.isFormValid = false,
      this.id,
      this.attachmentUrl,
      this.description = ''});

  InvoiceFormState copyWith(
      {bool? isFormValid,
      String? id,
      String? description,
      String? attachmentUrl}) {
    return InvoiceFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        description: description ?? this.description,
        attachmentUrl: attachmentUrl ?? this.attachmentUrl);
  }
}
