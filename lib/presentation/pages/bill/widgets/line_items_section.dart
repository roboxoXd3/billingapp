import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/bill_line_item.dart';
import 'line_item_card.dart';
import 'line_item_form.dart';

class LineItemsSection extends StatelessWidget {
  final List<BillLineItem> lineItems;
  final Function(BillLineItem) onAdd;
  final Function(int, BillLineItem) onEdit;
  final Function(int) onDelete;

  const LineItemsSection({
    super.key,
    required this.lineItems,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(context.l10n.items,
                        style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addLineItem(context),
                    ),
                  ],
                ),
                Text(
                  '${context.l10n.total}: ₹${_calculateTotal()}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (lineItems.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    context.l10n.noItemsYet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...lineItems.asMap().entries.map((entry) {
                return LineItemCard(
                  item: entry.value,
                  index: entry.key,
                  onEdit: (index) => _editLineItem(context, index),
                  onDelete: onDelete,
                );
              }),
          ],
        ),
      ),
    );
  }

  Future<void> _addLineItem(BuildContext context) async {
    final result = await showModalBottomSheet<BillLineItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LineItemForm(),
    );

    if (result != null) {
      onAdd(result);
    }
  }

  Future<void> _editLineItem(BuildContext context, int index) async {
    final result = await showModalBottomSheet<BillLineItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LineItemForm(item: lineItems[index]),
    );

    if (result != null) {
      onEdit(index, result);
    }
  }

  String _calculateTotal() {
    final total = lineItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    return total.toStringAsFixed(2);
  }
}
