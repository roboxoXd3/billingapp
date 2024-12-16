import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BillHeader extends StatelessWidget {
  final String billNumber;

  const BillHeader({super.key, required this.billNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.billNumber,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(billNumber, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
