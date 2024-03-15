import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/presentation/providers/providers.dart';
import 'package:factura24/features/shared/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:factura24/features/shared/infrastructure/services/colorsMatchCategory.dart';
import 'package:factura24/features/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceScreen extends ConsumerWidget {
  final String categoryInvoiceId;
  final String categoryInvoiceColor;
  final String categoryInvoiceTitle;
  final String idInvoice;

  const InvoiceScreen({
    Key? key,
    required this.categoryInvoiceId,
    required this.categoryInvoiceColor,
    required this.categoryInvoiceTitle,
    required this.idInvoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceProvider({
      'invoiceId': idInvoice,
      'categoryId': categoryInvoiceId, // Agregar categoryId al parámetro
    }));

    final invoiceForm =ref.watch(invoiceFormProvider(invoiceState.invoice!));

    final Color borderColor =
        getColorByName(categoryInvoiceColor).withAlpha(400);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorByName(categoryInvoiceColor).withAlpha(400),
        title: Text(
          'Crear factura "${invoiceForm.description}"',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
          child: InvoiceInformation(
            invoice: invoiceState.invoice!,
            borderColor: borderColor,
            invoiceForm: invoiceForm,
          ),
        ),
      ),
    );
  }
}

class InvoiceInformation extends ConsumerWidget {
  const InvoiceInformation({
    Key? key,
    required this.invoice,
    required this.borderColor,
    required this.invoiceForm,
  }) : super(key: key);

  final InvoiceEntity invoice;
  final Color borderColor;
  final InvoiceFormState? invoiceForm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceData = ref.watch(invoiceFormProvider(invoice));
    // Obtener el valor de la descripción

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (invoiceData.image != null)
          SizedBox(
              height: 150,
              child: Image.network(
                invoiceData.image!,
                fit: BoxFit.cover,
              )),
        SizedBox(height: invoiceData.image != null ? 16 : 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final galleryPath =
                    await CameraGalleryServiceImpl().selectPhoto();
                if (galleryPath == null) return;
                ref
                    .read(invoiceFormProvider(invoice).notifier)
                    .updateInvoiceImage(galleryPath);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Galería'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final photoPath = await CameraGalleryServiceImpl().takePhoto();
                if (photoPath == null) return;
                ref
                    .read(invoiceFormProvider(invoice).notifier)
                    .updateInvoiceImage(photoPath);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cámara'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Descripción: ${invoiceForm?.description}', // Mostrar el valor de la descripción aquí
          style: const TextStyle(fontSize: 16),
        ),
        CustomInvoiceInput(
          label: 'Descripción',
          maxLength: 200,
          maxLines: 5,
          borderColor: borderColor,
          initialValue: invoiceForm?.description ?? '',
          onChanged: ref
              .read(invoiceFormProvider(invoice).notifier)
              .onDescriptionChanged,
        ),
      ],
    );
  }
}
