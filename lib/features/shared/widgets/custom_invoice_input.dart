import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInvoiceInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor;
  final String? initialValue;

  const CustomInvoiceInput(
      {Key? key,
      this.label,
      this.hint,
      this.errorMessage,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.maxLength,
      this.maxLines,
      this.borderColor,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const borderRadius = Radius.circular(10);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                label!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black,
                ),
              ),
            ),
          TextFormField(
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            initialValue: initialValue,
            style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? colors.primary),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              ),
              isDense: true,
              hintText: hint,
              errorText: errorMessage,
              focusColor: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
