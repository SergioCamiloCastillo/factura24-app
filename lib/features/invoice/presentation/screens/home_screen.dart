import 'package:factura24/features/invoice/domain/entities/category_invoice_entity.dart';
import 'package:factura24/features/invoice/presentation/providers/categories_invoices_provider.dart';
import 'package:factura24/features/invoice/presentation/providers/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF06B981),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Agregar categoría',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF06B981))),
                    SizedBox(
                      width: 5,
                    )
                  ],
                )),
          ],
          title: const Text('Facturas',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: CarouselTabsScreen(),
        ));
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
          title: const Text(
            'Agrega nueva categoría de factura',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                final notifier = ref.read(nowCategoriesProvider.notifier);
                notifier.addCategory(
                  CategoryInvoiceEntity(
                    id: '50',
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

  int selectedCard = 0;

  final List<Map<String, dynamic>> colors = [
    {'nameColor': 'red', 'color': Colors.pinkAccent},
    {'nameColor': 'blue', 'color': Colors.lightBlue},
    {'nameColor': 'green', 'color': Colors.lightGreen},
    {'nameColor': 'yellow', 'color': Colors.yellowAccent},
    {'nameColor': 'purple', 'color': Colors.purpleAccent},
    {'nameColor': 'brown', 'color': const Color(0xFFB88E74)},
    {'nameColor': 'orange', 'color': Colors.orangeAccent},
    {'nameColor': 'beige', 'color': const Color(0xFFF5F5DC)},
    {'nameColor': 'pink', 'color': Colors.pinkAccent}
  ];

  void updateSelectedCard(int index) {
    setState(() {
      selectedCard = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesInvoiceState = ref.watch(nowCategoriesProvider);
    final invoicesState = ref.watch(invoicesProvider);
    List<Map<String, dynamic>> matchingColorsData =
        categoriesInvoiceState.map((category) {
      var colorData = colors.firstWhere(
          (colorMap) => colorMap['nameColor'] == category.color,
          orElse: () => null!);
      return colorData != null
          ? {'color': colorData['color']}
          : {
              'color': Colors.black
            }; // Si hay coincidencia, devuelve el color correspondiente, de lo contrario, negro
    }).toList();
    return categoriesInvoiceState.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 75.0, // Altura fija para las tarjetas
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                        width: 6.0); // Espacio horizontal entre las tarjetas
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesInvoiceState.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = categoriesInvoiceState[index];
                    return GestureDetector(
                      onTap: () {
                        updateSelectedCard(index);
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
                                    color: selectedCard == index
                                        ? matchingColorsData[index]['color']
                                            .withAlpha(
                                                200) // Cambia el valor alpha según lo deseado
                                        : matchingColorsData[index]['color'],
                                    elevation:
                                        selectedCard == index ? 8.0 : 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: BorderSide(
                                        color: Colors.red,
                                        width: selectedCard == index ? 2.0 : 0,
                                        style: selectedCard == index
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
                                    const Text(
                                      '3 facturas',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(
                                          0xff59656F,
                                        ), // Mantener el color del texto sin opacidad
                                      ),
                                    )
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
                    return ListTile(
                      title: Text(invoice.description),
                      subtitle: Text(invoice.description),
                    );
                  },
                ),
              ),
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
                      context.push('/invoice/$selectedCard');
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
                const Text('!Sin categorías de facturas!',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Por favor, toca el botón de agregar categoría para crear una nueva categoría de factura',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF59656F)),
                  ),
                )
              ],
            ),
          );
  }
}
