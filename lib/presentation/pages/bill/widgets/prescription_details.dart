import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrescriptionDetails extends StatelessWidget {
  final Function(String, dynamic) onDynamicValueChanged;
  final Map<String, dynamic> medicalHistory;

  const PrescriptionDetails({
    super.key,
    required this.onDynamicValueChanged,
    required this.medicalHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.prescriptionDetails,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildEyeDetails(context, isRight: true),
            const SizedBox(height: 16),
            _buildEyeDetails(context, isRight: false),
            const SizedBox(height: 24),
            _buildAddPower(context),
            const SizedBox(height: 24),
            _buildVisualAcuity(context),
            const SizedBox(height: 24),
            _buildMedicalHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeDetails(BuildContext context, {required bool isRight}) {
    final side = isRight ? 'Right' : 'Left';
    final label = isRight ? context.l10n.rightEye : context.l10n.leftEye;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: context.l10n.spherical,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (value) => onDynamicValueChanged(
                    'spherical$side', double.tryParse(value) ?? 0.0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: context.l10n.cylindrical,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (value) => onDynamicValueChanged(
                    'cylindrical$side', double.tryParse(value) ?? 0.0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: context.l10n.axis,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => onDynamicValueChanged(
                    'axis$side', int.tryParse(value) ?? 0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPower(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: '${context.l10n.add} (${context.l10n.rightEye})',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => onDynamicValueChanged(
                'addRight', double.tryParse(value) ?? 0.0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: '${context.l10n.add} (${context.l10n.leftEye})',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                onDynamicValueChanged('addLeft', double.tryParse(value) ?? 0.0),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualAcuity(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText:
                  '${context.l10n.visualAcuity} (${context.l10n.rightEye})',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) =>
                onDynamicValueChanged('visualAcuityRight', value),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText:
                  '${context.l10n.visualAcuity} (${context.l10n.leftEye})',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) =>
                onDynamicValueChanged('visualAcuityLeft', value),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.medicalHistory,
            style: Theme.of(context).textTheme.titleSmall),
        ...{
          'diabetic': context.l10n.diabetic,
          'hypertensive': context.l10n.hypertensive,
          'cardiac': context.l10n.cardiac,
          'asthmatic': context.l10n.asthmatic,
          'allergicToDrug': context.l10n.allergicToDrug,
        }.entries.map((entry) => CheckboxListTile(
              title: Text(entry.value),
              value: medicalHistory[entry.key] ?? false,
              onChanged: (bool? value) {
                final updatedHistory = Map<String, bool>.from(medicalHistory);
                updatedHistory[entry.key] = value ?? false;
                onDynamicValueChanged('medicalHistory', updatedHistory);
              },
            )),
      ],
    );
  }
}
