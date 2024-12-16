import 'package:flutter/material.dart';
import '../../../../domain/entities/bill_item.dart';
import 'bill_list_item.dart';

class BillList extends StatelessWidget {
  final List<BillItem> bills;

  const BillList({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bills.length,
      itemBuilder: (context, index) => BillListItem(bill: bills[index]),
    );
  }
}
