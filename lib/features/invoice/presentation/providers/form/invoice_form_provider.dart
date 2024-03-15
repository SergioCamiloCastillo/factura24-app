import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final invoiceFormProvider = StateNotifierProvider.autoDispose
    .family<InvoiceFormNotifier, InvoiceFormState, InvoiceEntity>(
        (ref, invoice) {
  //TODO: Createupdate callback
  return InvoiceFormNotifier(invoice: invoice);
});

class InvoiceFormNotifier extends StateNotifier<InvoiceFormState> {
  final void Function(Map<String, dynamic> invoiceLike)? onSubmitCallback;

  InvoiceFormNotifier({this.onSubmitCallback, required InvoiceEntity invoice})
      : super(InvoiceFormState(
            id: invoice.id,
            image: invoice.attachmentUrl,
            description: invoice.description ?? ''));

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
    //quitar idFormValid porque no es obligatorio
    //isFormValid: Formz.validate([Description.dirty(value)])
  }

  Future<bool> onFormSubmit() async {
    _touchEveryThing();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;
    final invoiceLike = {
      'id': state.id == 'new' ? null : state.id,
      'description': state.description,
      'attachmentUrl': state.image,
    };
    return true;
  }

  void _touchEveryThing() {
    state = state.copyWith();
  }

  void updateInvoiceImage(String path) {
    state = state.copyWith(image: path);
  }
}

class InvoiceFormState {
  final bool isFormValid;
  final String? id;
  final String description;
  final String? image;

  InvoiceFormState(
      {this.isFormValid = false, this.id, this.image, this.description = ''});

  InvoiceFormState copyWith(
      {bool? isFormValid, String? id, String? description, String? image}) {
    return InvoiceFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        description: description ?? this.description,
        image: image ?? this.image);
  }
}
