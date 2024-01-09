import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Facturas',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF06B981),
          onPressed: () => _dialogBuilder(context),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CarouselTabsScreen(),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Agrega nueva categoría de factura',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ingrese nombre de la categoría',
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CarouselTabsScreen extends StatefulWidget {
  const CarouselTabsScreen({super.key});

  @override
  _CarouselTabsScreenState createState() => _CarouselTabsScreenState();
}

class _CarouselTabsScreenState extends State<CarouselTabsScreen> {
  int selectedCard = 0;

  final List<Map<String, dynamic>> categoriesInvoice = [
    {'color': 'red', 'title': 'Agua'},
    {'color': 'blue', 'title': 'Luz'},
    {'color': 'green', 'title': 'Gas'},
    {'color': 'yellow', 'title': 'Internet y Teléfono'},
    {'color': 'brown', 'title': 'Claro'},
    {'color': 'orange', 'title': 'Netflix'},
  ];
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
    List<Map<String, dynamic>> matchingColorsData =
        categoriesInvoice.map((category) {
      var colorData = colors.firstWhere(
          (colorMap) => colorMap['nameColor'] == category['color'],
          orElse: () => null!);
      return colorData != null
          ? {'color': colorData['color']}
          : {
              'color': Colors.black
            }; // Si hay coincidencia, devuelve el color correspondiente, de lo contrario, negro
    }).toList();

    return Column(
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
            itemCount: categoriesInvoice.length,
            itemBuilder: (BuildContext context, int index) {
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
                            opacity:
                                0.2, // Cambia este valor para ajustar la opacidad
                            child: Card(
                              margin: const EdgeInsets.all(0.0),
                              color: matchingColorsData[index]['color'],
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
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
                                categoriesInvoice[index]['title'],
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
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información de la tarjeta seleccionada:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Contenido para la tarjeta ${selectedCard + 1}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
