import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:intl/intl.dart';

import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/invoice/presentation/providers/categories_invoices_provider.dart';
import 'package:factura24/features/invoice/presentation/providers/form/invoice_form_provider.dart';
import 'package:factura24/features/invoice/presentation/providers/invoices_provider.dart';
import 'package:factura24/features/shared/infrastructure/services/colorsMatchCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerWidget {
  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          actions: [
            GestureDetector(
                onTap: () => _dialogBuilder(context, ref),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF06B981),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Agregar categoría',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF06B981))),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                )),
          ],
          title: Text('Facturas',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: CarouselTabsScreen(),
        ));
  }

  String generateHash(String input) {
    List<int> bytes = utf8.encode(input);

    int hash = Random().nextInt(1000);

    const mixFactor = 31;

    for (int byte in bytes) {
      hash = (hash * mixFactor) ^ byte;
    }

    String hexHash = hash.toRadixString(16);

    return hexHash;
  }

  Future<void> _dialogBuilder(BuildContext context, WidgetRef ref) {
    TextEditingController categoryController =
        TextEditingController(); // Controlador para el TextField
    List<Map<String, String>> listColors = [
      {'label': 'Verde', 'value': 'green'},
      {'label': 'Rojo', 'value': 'red'},
      {'label': 'Azul', 'value': 'blue'},
      {'label': 'Amarillo', 'value': 'yellow'},
      {'label': 'Morado', 'value': 'purple'},
      {'label': 'Café', 'value': 'brown'},
      {'label': 'Naranja', 'value': 'orange'},
      {'label': 'Beige', 'value': 'beige'},
      {'label': 'Rosa', 'value': 'pink'}
    ];
    Map<String, String> selectedColor = listColors.first;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Agrega nueva categoría de factura',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese nombre de la categoría',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _DropDownColor(
                  listColors: listColors,
                  dropdownValue: selectedColor,
                  onChanged: (value) {
                    selectedColor = value;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Agregar'),
              onPressed: () {
                DateTime now = DateTime.now();

                // Convierte la fecha y hora a una cadena formateada
                String formattedDateTime =
                    "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";

                // Calcula el hash utilizando una función hash básica
                String hash = generateHash(formattedDateTime);

                final notifier = ref.read(nowCategoriesProvider.notifier);
                notifier.addCategory(
                  CategoryInvoiceEntity(
                    id: hash,
                    user: 1,
                    title: categoryController.text,
                    color: selectedColor['value']!,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _DropDownColor extends StatefulWidget {
  const _DropDownColor({
    Key? key,
    required this.listColors,
    required this.dropdownValue,
    required this.onChanged,
  }) : super(key: key);

  final List<Map<String, String>> listColors;
  final Map<String, String> dropdownValue;
  final ValueChanged<Map<String, String>> onChanged;

  @override
  State<_DropDownColor> createState() => _DropDownColorState();
}

class _DropDownColorState extends State<_DropDownColor> {
  late Map<String, String> dropdownValue;
  Map<String, Color> colorMap = {
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'purple': Colors.purple,
    'brown': const Color(0xFFB88E74),
    'orange': Colors.orange,
    'beige': const Color(0xFFF5F5DC),
    'pink': Colors.pink
    // Agrega más colores según necesites
  };

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Selecciona un color de la categoría',
              contentPadding: EdgeInsets.symmetric(
                  vertical: 2, horizontal: 10), // Reducir el espacio interno
            ),
            child: DropdownButton<Map<String, String>>(
              value: dropdownValue,
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                  widget.onChanged(value);
                });
              },
              items:
                  widget.listColors.map<DropdownMenuItem<Map<String, String>>>(
                (color) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          color: colorMap[color['value']!] ?? Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(color['label']!),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class CarouselTabsScreen extends ConsumerStatefulWidget {
  const CarouselTabsScreen({super.key});

  @override
  _CarouselTabsScreenState createState() => _CarouselTabsScreenState();
}

class _CarouselTabsScreenState extends ConsumerState {
  String capitalize(String s) {
    return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(nowCategoriesProvider.notifier).loadCategories();
  }

  Map<String, dynamic> _getSelectedCardInfo() {
    final selectedCategory = ref
        .read(nowCategoriesProvider)
        .categories
        .firstWhere((category) => category.id == selectedCard,
            orElse: () => null!);

    return {
      'id': selectedCategory.id,
      'title': selectedCategory.title,
      'color': selectedCategory.color,
    };
  }

  String selectedCard = '';

  final List<Map<String, dynamic>> colors = globalColors;
  void updateSelectedCard(String index) async {
    setState(() {
      selectedCard = index;
    });
  }

  void _showModal(BuildContext context, WidgetRef ref,
      CategoryInvoiceEntity categoryToDelete) {
    final categoryNotifier = ref.read(nowCategoriesProvider.notifier);
    final invoiceNotifier = ref.read(invoicesProvider.notifier);
    // Show modal after a 2-second delay
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '¿Que deseas hacer con la categoría "${capitalize(categoryToDelete.title)}"?'),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para editar aquí
                      Navigator.of(context)
                          .pop(); // Cerrar el Dialog después de editar
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      // Lógica para borrar aquí
                      categoryNotifier.deleteCategory(categoryToDelete);
                      // Actualiza selectedCard
                      final categoriesData = ref.read(nowCategoriesProvider);
                      updateSelectedCard(categoriesData.categories.isNotEmpty
                          ? categoriesData.categories.first.id
                          : '');
                      Navigator.of(context)
                          .pop(); // Cerrar el Dialog después de borrar
                      var snackBar = SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red.shade400,
                        content: const Text('Categoría eliminada exitosamente',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      );
                      context.pushReplacement('/');
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Eliminar',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesInvoiceState = ref.watch(nowCategoriesProvider);

    final invoicesState = ref.watch(invoicesProvider);
    selectedCard = selectedCard.isNotEmpty
        ? selectedCard
        : categoriesInvoiceState.categories.isNotEmpty
            ? categoriesInvoiceState.categories.first.id
            : '';

    List<Map<String, dynamic>> matchingColorsData =
        categoriesInvoiceState.categories.map((category) {
      var colorData = colors.firstWhere(
          (colorMap) => colorMap['nameColor'] == category.color,
          orElse: () => null!);
      return colorData != null
          ? {'color': colorData['color']}
          : {
              'color': Colors.black
            }; // Si hay coincidencia, devuelve el color correspondiente, de lo contrario, negro
    }).toList();

    return categoriesInvoiceState.categories.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.0, // Altura fija para las tarjetas
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                        width: 6.0); // Espacio horizontal entre las tarjetas
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesInvoiceState.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = categoriesInvoiceState.categories[index];
                    return GestureDetector(
                      onLongPress: () {
                        final timer = Timer(
                          const Duration(seconds: 1),
                          () {
                            _showModal(context, ref, category);
                          },
                        );
                      },
                      onTap: () {
                        updateSelectedCard(category.id);
                        final notifier =
                            ref.read(nowCategoriesProvider.notifier);
                        notifier.changeCategorySelected(category.id);
                      },
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: 130.0, // Ancho fijo para las tarjetas
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Card(
                                    margin: const EdgeInsets.all(0.0),
                                    color: selectedCard == category.id
                                        ? matchingColorsData[index]['color']
                                            .withAlpha(
                                                200) // Cambia el valor alpha según lo deseado
                                        : matchingColorsData[index]['color'],
                                    elevation:
                                        selectedCard == category.id ? 8.0 : 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: BorderSide(
                                        color: Colors.red,
                                        width: selectedCard == category.id
                                            ? 2.0
                                            : 0,
                                        style: selectedCard == category.id
                                            ? BorderStyle.solid
                                            : BorderStyle.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Alinear el contenido a la izquierda
                                  children: [
                                    Text(
                                      capitalize(category.title),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(
                                          0xff59656F,
                                        ), // Mantener el color del texto sin opacidad
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: invoicesState.invoices.length,
                itemBuilder: (BuildContext context, int index) {
                  final invoice = invoicesState.invoices[index];
                  String createdAtString = invoice.createdAt;
                  DateTime createdAt = DateTime.parse(createdAtString);
                  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                  String formattedDate = dateFormat.format(createdAt);

                  return GestureDetector(
                    onTap: () {
                      if (invoice.attachmentUrl != null &&
                          invoice.attachmentUrl!.isNotEmpty) {
                        print('pudeee=>${invoice.attachmentUrl}');
                        showImageViewer(
                            context, FileImage(File(invoice.attachmentUrl!)));
                      }
                    },
                    child: Card(
                      elevation: 4, // Elevación de la tarjeta
                      margin: const EdgeInsets.symmetric(
                          vertical: 8), // Márgenes de la tarjeta
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Bordes redondeados
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(
                            16), // Relleno interno de la lista
                        title: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(invoice.description ?? ''),
                        trailing: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8), // Bordes redondeados de la imagen
                          child: Image.file(
                            File(invoice.attachmentUrl!),
                            width: 100,
                            height: 100,
                            fit: BoxFit
                                .cover, // Ajustar imagen al tamaño del contenedor
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35.0, right: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFF06B981),
                      padding: const EdgeInsets.all(15.0),
                    ),
                    onPressed: () {
                      final selectedCardInfo = _getSelectedCardInfo();
                      context.push(
                          '/invoice/${selectedCardInfo['id']}/${selectedCardInfo['color']}/${selectedCardInfo['title']}/new');
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/box-empty.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('!Sin categorías de facturas!',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Por favor, toca el botón de agregar categoría para crear una nueva categoría de factura',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF59656F)),
                  ),
                )
              ],
            ),
          );
  }
}
