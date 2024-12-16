import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int itemCount;
  final String total;
  final VoidCallback? onSave;
  final VoidCallback? onPrint;

  const BottomBar({
    super.key,
    required this.itemCount,
    required this.total,
    this.onSave,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${context.l10n.totalItems}: $itemCount'),
                Text(
                  '${context.l10n.grandTotal}: ₹$total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: itemCount > 0 ? onSave : null,
            child: const Icon(Icons.save),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: itemCount > 0 ? onPrint : null,
            child: const Icon(Icons.print),
          ),
        ],
      ),
    );
  }
}
