import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/field/field_bloc.dart';
import '../../../bloc/field/field_state.dart';
import 'dynamic_field.dart';

class DynamicFieldsSection extends StatelessWidget {
  final Map<String, dynamic> dynamicValues;
  final Function(String, dynamic) onValueChanged;

  const DynamicFieldsSection({
    super.key,
    required this.dynamicValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldBloc, FieldState>(
      builder: (context, state) {
        if (state is FieldsLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.additionalFields,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ...state.fields
                      .map((field) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DynamicField(
                              field: field,
                              initialValue: dynamicValues[field.fieldId],
                              onChanged: (value) =>
                                  onValueChanged(field.fieldId, value),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
