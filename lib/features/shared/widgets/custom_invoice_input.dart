import 'package:flutter/material.dart';

class CustomInvoiceInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomInvoiceInput({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(borderRadius),
      ),
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
