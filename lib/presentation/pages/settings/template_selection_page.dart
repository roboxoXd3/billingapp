import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/utils/constants.dart';
import '../../bloc/settings/settings_bloc.dart';

class TemplateSelectionPage extends StatelessWidget {
  const TemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectTemplate),
      ),
      body: ListView.builder(
        itemCount: availableTemplates.length,
        itemBuilder: (context, index) {
          final template = availableTemplates.entries.elementAt(index);
          return RadioListTile<String>(
            title: Text(template.value),
            value: template.key,
            groupValue: context.watch<SettingsBloc>().state.selectedTemplate,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                      TemplateChanged(value),
                    );
              }
            },
          );
        },
      ),
    );
  }
}
