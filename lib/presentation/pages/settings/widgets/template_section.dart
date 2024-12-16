import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/utils/constants.dart';
import '../../../bloc/settings/settings_bloc.dart';

class TemplateSection extends StatelessWidget {
  const TemplateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectTemplate,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Column(
                children: availableTemplates.entries.map((template) {
                  return RadioListTile<String>(
                    title: Text(template.value),
                    value: template.key,
                    groupValue: state.selectedTemplate,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(
                              TemplateChanged(value),
                            );
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
