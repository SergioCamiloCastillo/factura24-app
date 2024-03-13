import 'package:factura24/features/invoice/presentation/providers/invoice_provider.dart';
import 'package:factura24/features/shared/infrastructure/services/colorsMatchCategory.dart';
import 'package:factura24/features/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceScreen extends ConsumerWidget {
  final String categoryInvoiceId;
  final String categoryInvoiceColor;
  final String categoryInvoiceTitle;
  final String idInvoice;
  const InvoiceScreen(
      {super.key,
      required this.categoryInvoiceId,
      required this.categoryInvoiceColor,
      required this.categoryInvoiceTitle,
      required this.idInvoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceProvider(idInvoice));
    final Color borderColor =
        getColorByName(categoryInvoiceColor).withAlpha(400);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: getColorByName(categoryInvoiceColor).withAlpha(400),
          title: Text(
            'Crear factura "$categoryInvoiceTitle"',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
            child: Column(children: [
              CustomInvoiceInput(
                label: 'Descripción',
                maxLength: 200,
                maxLines: 5,
                borderColor: borderColor,
              )
            ]),
          ),
        ));
  }
}
