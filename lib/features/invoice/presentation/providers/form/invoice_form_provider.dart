import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class InoviceFormNotifier extends StateNotifier<InvoiceFormState> {
  final void Function(Map<String, dynamic> invoiceLike)? onSubmitCallback;

  InoviceFormNotifier({this.onSubmitCallback, required InvoiceEntity invoice})
      : super(InvoiceFormState(
            id: invoice.id,
            description: Description.dirty(invoice.description ?? '')));

  void onDescriptionChanged(String value) {
    final description = Description.dirty(value);
    state = state.copyWith(
        description: description,
        //quitar idFormValid porque no es obligatorio
        isFormValid: Formz.validate([Description.dirty(value)]));
  }

  void _touchEveryThing() {
    state = state.copyWith(
        isFormValid: Formz.validate(
            [Description.dirty(state.description?.value ?? '')]));
  }
}

class InvoiceFormState {
  final bool isFormValid;
  final String? id;
  final Description? description;

  InvoiceFormState(
      {this.isFormValid = false,
      this.id,
      this.description = const Description.dirty('')});

  InvoiceFormState copyWith(
      {bool? isFormValid, String? id, Description? description}) {
    return InvoiceFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        description: description ?? this.description);
  }
}
