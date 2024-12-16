import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/services/preference_service.dart';
import 'core/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/usecases/bill/delete_bill.dart';
import 'domain/usecases/bill/get_bills.dart';
import 'domain/usecases/bill/save_bill.dart';
import 'domain/usecases/company/get_company_details.dart';
import 'domain/usecases/company/save_company_details.dart';
import 'domain/usecases/field/delete_field.dart';
import 'domain/usecases/field/get_fields.dart';
import 'domain/usecases/field/save_field.dart';
import 'presentation/bloc/bill/bill_bloc.dart';
import 'presentation/bloc/bill/bill_event.dart';
import 'presentation/bloc/company/company_bloc.dart';
import 'presentation/bloc/company/company_event.dart';
import 'presentation/bloc/field/field_bloc.dart';
import 'presentation/bloc/field/field_event.dart';
import 'presentation/bloc/settings/settings_bloc.dart';
import 'presentation/bloc/language/language_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'domain/repositories/bill_repository.dart';
import 'domain/repositories/company_repository.dart';
import 'domain/repositories/field_repository.dart';
import 'data/repositories/bill_repository_impl.dart';
import 'data/repositories/company_repository_impl.dart';
import 'data/repositories/field_repository_impl.dart';
import 'data/datasources/local/database_helper.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Register services with GetIt
  getIt.registerSingleton<PreferencesService>(
      PreferencesService(sharedPreferences));

  // Register DatabaseHelper
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());

  // Register Repositories
  getIt.registerSingleton<BillRepository>(
      BillRepositoryImpl(getIt<DatabaseHelper>()));
  getIt.registerSingleton<CompanyRepository>(
      CompanyRepositoryImpl(getIt<DatabaseHelper>()));
  getIt.registerSingleton<FieldRepository>(
      FieldRepositoryImpl(getIt<DatabaseHelper>()));

  // Register Use Cases
  // Bill Use Cases
  getIt.registerFactory(() => GetBills(getIt<BillRepository>()));
  getIt.registerFactory(() => SaveBill(getIt<BillRepository>()));
  getIt.registerFactory(() => DeleteBill(getIt<BillRepository>()));

  // Company Use Cases
  getIt.registerFactory(() => GetCompanyDetails(getIt<CompanyRepository>()));
  getIt.registerFactory(() => SaveCompanyDetails(getIt<CompanyRepository>()));

  // Field Use Cases
  getIt.registerFactory(() => GetFields(getIt<FieldRepository>()));
  getIt.registerFactory(() => SaveField(getIt<FieldRepository>()));
  getIt.registerFactory(() => DeleteField(getIt<FieldRepository>()));

  // Register BLoCs with GetIt
  getIt.registerFactory<BillBloc>(() => BillBloc(
        getIt<GetBills>(),
        getIt<SaveBill>(),
        getIt<DeleteBill>(),
      )..add(LoadBills()));

  getIt.registerFactory<CompanyBloc>(() => CompanyBloc(
        getIt<GetCompanyDetails>(),
        getIt<SaveCompanyDetails>(),
      )..add(LoadCompanyDetails()));

  getIt.registerFactory<FieldBloc>(() => FieldBloc(
        getIt<GetFields>(),
        getIt<SaveField>(),
        getIt<DeleteField>(),
      )..add(LoadFields()));

  getIt.registerFactory<SettingsBloc>(() => SettingsBloc());
  getIt.registerFactory<LanguageCubit>(() => LanguageCubit());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BillBloc>(
          create: (_) => getIt<BillBloc>(),
        ),
        BlocProvider<CompanyBloc>(
          create: (_) => getIt<CompanyBloc>(),
        ),
        BlocProvider<FieldBloc>(
          create: (_) => getIt<FieldBloc>(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => getIt<LanguageCubit>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => getIt<SettingsBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Billing App',
            locale: locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.generateRoute,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            initialRoute: '/', // Always start with splash screen
          );
        },
      ),
    );
  }
}
