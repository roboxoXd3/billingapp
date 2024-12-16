import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/company/get_company_details.dart';
import '../../../domain/usecases/company/save_company_details.dart';
import 'company_event.dart';
import 'company_state.dart';

@injectable
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final GetCompanyDetails _getCompanyDetails;
  final SaveCompanyDetails _saveCompanyDetails;

  CompanyBloc(
    this._getCompanyDetails,
    this._saveCompanyDetails,
  ) : super(CompanyInitial()) {
    on<LoadCompanyDetails>(_onLoadCompanyDetails);
    on<SaveCompanyDetailsEvent>(_onSaveCompanyDetails);
    on<UpdateLogoEvent>(_onUpdateLogo);
  }

  Future<void> _onLoadCompanyDetails(
    LoadCompanyDetails event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await _getCompanyDetails(NoParams());
    result.fold(
      (failure) => emit(CompanyError(failure.message)),
      (details) => emit(CompanyLoaded(details)),
    );
  }

  Future<void> _onSaveCompanyDetails(
    SaveCompanyDetailsEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await _saveCompanyDetails(event.details);
    result.fold(
      (failure) => emit(CompanyError(failure.message)),
      (_) => emit(CompanySaved(event.details)),
    );
  }

  Future<void> _onUpdateLogo(
    UpdateLogoEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    // Get current details
    final currentDetails = await _getCompanyDetails(NoParams());

    final result = await currentDetails.fold(
      (failure) {
        emit(CompanyError(failure.message));
        return null;
      },
      (details) async {
        // Update logo
        final updatedDetails = details.copyWith(logo: event.logoPath);
        final result = await _saveCompanyDetails(updatedDetails);

        result.fold(
          (failure) => emit(CompanyError(failure.message)),
          (_) => emit(LogoUpdated(event.logoPath)),
        );
        return null;
      },
    );
  }
}
