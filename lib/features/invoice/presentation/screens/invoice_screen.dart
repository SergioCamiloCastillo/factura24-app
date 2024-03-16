import 'dart:io';

import 'package:factura24/features/invoice/domain/entities/invoice_entity.dart';
import 'package:factura24/features/invoice/presentation/providers/providers.dart';
import 'package:factura24/features/shared/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:factura24/features/shared/infrastructure/services/colorsMatchCategory.dart';
import 'package:factura24/features/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    final invoiceForm = ref.watch(invoiceFormProvider);

    final Color borderColor =
        getColorByName(categoryInvoiceColor).withAlpha(400);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorByName(categoryInvoiceColor).withAlpha(400),
        title: const Text(
          'Crear factura',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
          child: InvoiceInformation(
            invoice: invoiceState.invoice!,
            borderColor: borderColor,
            invoiceForm: invoiceForm,
            onChangePhoto: (path) {
              ref
                  .read(invoiceFormProvider.notifier)
                  .onAttachmentUrlChanged(path);
            },
            onChangedDescription: (value) {
              ref
                  .read(invoiceFormProvider.notifier)
                  .onDescriptionChanged(value);
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[200],
        child: ElevatedButton(
          onPressed: () {
            // Verificar si se ha adjuntado una imagen antes de guardar la factura
            if (invoiceForm.attachmentUrl == null ||
                invoiceForm.attachmentUrl!.isEmpty) {
              // Mostrar un diálogo o una notificación indicando que la imagen es obligatoria
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'Debes adjuntar una imagen o archivo antes de guardar la factura.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            } else {
              ref
                  .read(invoiceFormProvider.notifier)
                  .onFormSubmit(categoryInvoiceId)
                  .then((isFormValid) {
                print('isFormValid=>$isFormValid');
                if (isFormValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Factura guardada exitosamente'),
                      duration: Duration(seconds: 2), // Duración del mensaje
                      backgroundColor: Colors.green, // Color del SnackBar
                    ),
                  );
                  Navigator.of(context)
                      .pop(); // Cerrar el Dialog después de borrar
                  final notifier = ref.read(nowCategoriesProvider.notifier);
                  notifier.changeCategorySelected(categoryInvoiceId);
                }
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Guardar factura',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class InvoiceInformation extends StatelessWidget {
  const InvoiceInformation({
    Key? key,
    required this.invoice,
    required this.borderColor,
    required this.invoiceForm,
    required this.onChangedDescription,
    required this.onChangePhoto,
  }) : super(key: key);

  final InvoiceEntity invoice;
  final Color borderColor;
  final InvoiceFormState? invoiceForm;
  final Function(String) onChangedDescription;
  final Function(String) onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final galleryPath =
                    await CameraGalleryServiceImpl().selectPhoto();
                if (galleryPath == null) return;
                onChangePhoto(galleryPath);
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
                onChangePhoto(photoPath);
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
        if (invoiceForm?.attachmentUrl != null &&
            invoiceForm!.attachmentUrl!.isNotEmpty)
          SizedBox(
            height: 150,
            child: Image.file(File(invoiceForm?.attachmentUrl ?? '')),
          ),
        const SizedBox(height: 16),
        CustomInvoiceInput(
            label: 'Descripción',
            maxLength: 200,
            maxLines: 5,
            borderColor: borderColor,
            initialValue: invoiceForm?.description ?? '',
            onChanged: onChangedDescription),
      ],
    );
  }
}
