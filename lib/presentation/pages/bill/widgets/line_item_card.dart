import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/bill_line_item.dart';
import '../../../../core/utils/constants.dart';

class LineItemCard extends StatelessWidget {
  final BillLineItem item;
  final int index;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const LineItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.type == billTypeSale
                    ? Colors.green[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.type == billTypeSale
                    ? context.l10n.sale
                    : context.l10n.returnText,
                style: TextStyle(
                  color: item.type == billTypeSale
                      ? Colors.green[900]
                      : Colors.red[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.l10n.quantity}: ${item.gross.toStringAsFixed(2)} - ${item.less.toStringAsFixed(2)} = ${item.net.toStringAsFixed(2)}',
            ),
            Text(
              '${context.l10n.rate}: ₹${item.rate.toStringAsFixed(2)}/unit',
            ),
            if (item.discount > 0)
              Text(
                  '${context.l10n.discount}: ${item.discount.toStringAsFixed(0)}%'),
            Text(
              '${context.l10n.total}: ₹${item.total.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.type == billTypeReturn ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(index),
            ),
          ],
        ),
        onTap: () => onEdit(index),
      ),
    );
  }
}
