import 'package:factura24/features/shared/infrastructure/services/colorsMatchCategory.dart';
import 'package:factura24/features/shared/widgets/custom_invoice_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String categoryInvoiceId;
  final String categoryInvoiceColor;
  final String categoryInvoiceTitle;
  const InvoiceScreen(
      {super.key,
      required this.categoryInvoiceId,
      required this.categoryInvoiceColor,
      required this.categoryInvoiceTitle});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              getColorByName(widget.categoryInvoiceColor).withAlpha(400),
          title: Text(
            'Crear factura "${widget.categoryInvoiceTitle}"',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: const Column(children: [CustomInvoiceInput()]));
  }
}
