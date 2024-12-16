import 'package:flutter/material.dart';
import '../domain/entities/bill_item.dart';
import '../presentation/pages/bill/add_edit_bill_page.dart';
import '../presentation/pages/bill/bill_details_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';
import '../presentation/pages/splash/splash_page.dart';
import 'package:flutter/foundation.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('Generating route for: ${settings.name}');
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      case '/add-bill':
        return MaterialPageRoute(builder: (_) => const AddEditBillPage());

      case '/edit-bill':
        final bill = settings.arguments as BillItem;
        return MaterialPageRoute(builder: (_) => AddEditBillPage(bill: bill));

      case '/bill-details':
        final bill = settings.arguments as BillItem;
        return MaterialPageRoute(builder: (_) => BillDetailsPage(bill: bill));

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      default:
        if (kDebugMode) {
          print('No route defined for ${settings.name}');
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
