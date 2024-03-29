import 'package:factura24/features/invoice/presentation/screens/home_screen.dart';
import 'package:factura24/features/invoice/presentation/screens/invoice_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
      path: "/",
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
    path:
        '/invoice/:categoryInvoiceId/:categoryInvoiceColor/:categoryInvoiceTitle/:idInvoice',
    name: 'invoice',
    builder: (context, state) => InvoiceScreen(
        categoryInvoiceId: state.pathParameters['categoryInvoiceId'] ?? 'new',
        categoryInvoiceColor:
            state.pathParameters['categoryInvoiceColor'] ?? 'no-color',
        categoryInvoiceTitle:
            state.pathParameters['categoryInvoiceTitle'] ?? '',
        idInvoice: state.pathParameters['idInvoice'] ?? ''),
  ),
]);
