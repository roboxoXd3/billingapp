import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/bill_item.dart';
import '../../../bloc/bill/bill_bloc.dart';
import '../../../bloc/bill/bill_event.dart';

class BillListItem extends StatelessWidget {
  final BillItem bill;

  const BillListItem({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(bill.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Bill'),
              content: const Text('Are you sure you want to delete this bill?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<BillBloc>().add(DeleteBillEvent(bill.id!));
      },
      child: ListTile(
        title: Text(bill.customerName),
        subtitle: Text(bill.billNumber),
        trailing: Text('₹${bill.grandTotal.toStringAsFixed(2)}'),
        onTap: () => Navigator.pushNamed(
          context,
          '/bill-details',
          arguments: bill,
        ),
      ),
    );
  }
}
