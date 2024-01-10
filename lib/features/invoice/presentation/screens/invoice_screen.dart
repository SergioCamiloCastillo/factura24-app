import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String categoryInvoiceId;
  const InvoiceScreen({super.key, required this.categoryInvoiceId});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear factura'),
        ),
        body: Center(
          child: Text('Product id ${widget.categoryInvoiceId}'),
        ));
  }
}
