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
        '/invoice/:categoryInvoiceId/:categoryInvoiceColor/:categoryInvoiceTitle',
    name: 'invoice',
    builder: (context, state) => InvoiceScreen(
        categoryInvoiceId: state.pathParameters['categoryInvoiceId'] ?? 'no-id',
        categoryInvoiceColor:
            state.pathParameters['categoryInvoiceColor'] ?? 'no-color',
        categoryInvoiceTitle: state.pathParameters['categoryInvoiceTitle'] ?? ''),
  ),
]);
