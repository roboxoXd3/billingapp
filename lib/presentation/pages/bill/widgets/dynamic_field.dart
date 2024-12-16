import 'package:flutter/material.dart';
import '../../../../domain/entities/field_config.dart';

class DynamicField extends StatelessWidget {
  final FieldConfig field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;

  const DynamicField({
    super.key,
    required this.field,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue?.toString() ?? field.defaultValue ?? '',
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
        ),
        keyboardType:
            field.type == 'number' ? TextInputType.number : TextInputType.text,
        validator: field.required
            ? (value) {
                if (value?.isEmpty ?? true) {
                  return '${field.label} is required';
                }
                if (field.type == 'number' && double.tryParse(value!) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          if (field.type == 'number') {
            onChanged(double.tryParse(value) ?? 0);
          } else {
            onChanged(value);
          }
        },
        enabled: !field.isCalculated,
      ),
    );
  }
}
