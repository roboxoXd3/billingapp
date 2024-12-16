import 'package:flutter/material.dart';
import '../../domain/entities/bill_item.dart';

class BillSearchDelegate extends SearchDelegate<String> {
  final List<BillItem> bills;

  BillSearchDelegate(this.bills);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = bills.where((bill) {
      return bill.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final bill = suggestions[index];
        return ListTile(
          title: Text(bill.customerName),
          subtitle: Text(bill.billNumber),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/bill-details',
              arguments: bill,
            );
          },
        );
      },
    );
  }
}
