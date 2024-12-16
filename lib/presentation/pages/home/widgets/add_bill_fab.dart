import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/bill/bill_bloc.dart';
import '../../../bloc/bill/bill_event.dart';

class AddBillFAB extends StatelessWidget {
  const AddBillFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/add-bill');
        if (!context.mounted) return;
        // Reload bills when returning from add/edit page
        context.read<BillBloc>().add(LoadBills());
      },
      child: const Icon(Icons.add),
    );
  }
}
