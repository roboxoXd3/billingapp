// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:billing_app/core/services/preference_service.dart' as _i98;
import 'package:billing_app/data/datasources/local/database_helper.dart'
    as _i755;
import 'package:billing_app/data/repositories/bill_repository_impl.dart'
    as _i220;
import 'package:billing_app/data/repositories/company_repository_impl.dart'
    as _i927;
import 'package:billing_app/data/repositories/field_repository_impl.dart'
    as _i492;
import 'package:billing_app/domain/repositories/bill_repository.dart' as _i558;
import 'package:billing_app/domain/repositories/company_repository.dart'
    as _i450;
import 'package:billing_app/domain/repositories/field_repository.dart' as _i721;
import 'package:billing_app/domain/usecases/bill/delete_bill.dart' as _i549;
import 'package:billing_app/domain/usecases/bill/get_bills.dart' as _i284;
import 'package:billing_app/domain/usecases/bill/save_bill.dart' as _i696;
import 'package:billing_app/domain/usecases/company/get_company_details.dart'
    as _i364;
import 'package:billing_app/domain/usecases/company/save_company_details.dart'
    as _i825;
import 'package:billing_app/domain/usecases/field/delete_field.dart' as _i231;
import 'package:billing_app/domain/usecases/field/get_fields.dart' as _i816;
import 'package:billing_app/domain/usecases/field/save_field.dart' as _i646;
import 'package:billing_app/injection.dart' as _i460;
import 'package:billing_app/presentation/bloc/bill/bill_bloc.dart' as _i767;
import 'package:billing_app/presentation/bloc/company/company_bloc.dart'
    as _i308;
import 'package:billing_app/presentation/bloc/field/field_bloc.dart' as _i564;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i755.DatabaseHelper>(() => _i755.DatabaseHelper());
    gh.singleton<_i98.PreferencesService>(
        () => _i98.PreferencesService(gh<_i460.SharedPreferences>()));
    gh.factory<_i558.BillRepository>(
        () => _i220.BillRepositoryImpl(gh<_i755.DatabaseHelper>()));
    gh.factory<_i721.FieldRepository>(
        () => _i492.FieldRepositoryImpl(gh<_i755.DatabaseHelper>()));
    gh.factory<_i450.CompanyRepository>(
        () => _i927.CompanyRepositoryImpl(gh<_i755.DatabaseHelper>()));
    gh.factory<_i364.GetCompanyDetails>(
        () => _i364.GetCompanyDetails(gh<_i450.CompanyRepository>()));
    gh.factory<_i825.SaveCompanyDetails>(
        () => _i825.SaveCompanyDetails(gh<_i450.CompanyRepository>()));
    gh.factory<_i696.SaveBill>(
        () => _i696.SaveBill(gh<_i558.BillRepository>()));
    gh.factory<_i284.GetBills>(
        () => _i284.GetBills(gh<_i558.BillRepository>()));
    gh.factory<_i549.DeleteBill>(
        () => _i549.DeleteBill(gh<_i558.BillRepository>()));
    gh.factory<_i308.CompanyBloc>(() => _i308.CompanyBloc(
          gh<_i364.GetCompanyDetails>(),
          gh<_i825.SaveCompanyDetails>(),
        ));
    gh.factory<_i816.GetFields>(
        () => _i816.GetFields(gh<_i721.FieldRepository>()));
    gh.factory<_i646.SaveField>(
        () => _i646.SaveField(gh<_i721.FieldRepository>()));
    gh.factory<_i231.DeleteField>(
        () => _i231.DeleteField(gh<_i721.FieldRepository>()));
    gh.factory<_i564.FieldBloc>(() => _i564.FieldBloc(
          gh<_i816.GetFields>(),
          gh<_i646.SaveField>(),
          gh<_i231.DeleteField>(),
        ));
    gh.factory<_i767.BillBloc>(() => _i767.BillBloc(
          gh<_i284.GetBills>(),
          gh<_i696.SaveBill>(),
          gh<_i549.DeleteBill>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i460.RegisterModule {}
