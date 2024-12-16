import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/company_form.dart';
import 'widgets/fields_section.dart';
import 'widgets/template_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.companyDetails),
              Tab(text: l10n.fields),
              Tab(text: l10n.template),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CompanyForm(),
            FieldsSection(),
            TemplateSection(),
          ],
        ),
      ),
    );
  }
}
