import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';

class CustomerDetails extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController locationController;

  const CustomerDetails({
    super.key,
    required this.nameController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.customerDetails,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l10n.customerName,
                border: const OutlineInputBorder(),
              ),
              validator: Validators.validateCustomerName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: context.l10n.location,
                border: const OutlineInputBorder(),
              ),
              validator: Validators.validateLocation,
            ),
          ],
        ),
      ),
    );
  }
}
