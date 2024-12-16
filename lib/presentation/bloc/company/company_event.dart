import 'package:equatable/equatable.dart';
import '../../../domain/entities/company_details.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompanyDetails extends CompanyEvent {}

class SaveCompanyDetailsEvent extends CompanyEvent {
  final CompanyDetails details;

  const SaveCompanyDetailsEvent(this.details);

  @override
  List<Object> get props => [details];
}

class UpdateLogoEvent extends CompanyEvent {
  final String logoPath;

  const UpdateLogoEvent(this.logoPath);

  @override
  List<Object> get props => [logoPath];
}
