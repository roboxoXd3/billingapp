import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/preference_service.dart';
import '../../../core/utils/constants.dart';
import '../../../domain/entities/company_details.dart';
import '../../bloc/company/company_bloc.dart';
import '../../bloc/company/company_event.dart';
import '../../bloc/settings/settings_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedTemplate = defaultTemplate;
  final PreferencesService _preferencesService;

  _OnboardingPageState() : _preferencesService = GetIt.I<PreferencesService>();

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final isCompleted = await _preferencesService.isOnboardingCompleted();
    if (isCompleted && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.setupBusiness,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  labelText: l10n.businessName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return l10n.businessNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: l10n.username,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return l10n.usernameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return l10n.phoneRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectTemplate,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...availableTemplates.entries.map((template) {
                return RadioListTile<String>(
                  title: Text(template.value),
                  value: template.key,
                  groupValue: _selectedTemplate,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTemplate = value;
                      });
                    }
                  },
                );
              }).toList(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(l10n.getStarted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save business details
      context.read<CompanyBloc>().add(
            SaveCompanyDetailsEvent(
              CompanyDetails(
                name: _businessNameController.text,
                address: '',
                phone: _phoneController.text,
                email: '',
              ),
            ),
          );

      // Save selected template
      context.read<SettingsBloc>().add(
            TemplateChanged(_selectedTemplate),
          );

      // Save onboarding completion status
      await _preferencesService.setOnboardingCompleted(true);

      // Navigate to home page
      if (mounted) {
        // Check if widget is still mounted
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
