import 'package:equatable/equatable.dart';
import '../../../domain/entities/company_details.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final CompanyDetails details;

  const CompanyLoaded(this.details);

  @override
  List<Object> get props => [details];
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);

  @override
  List<Object> get props => [message];
}

class CompanySaved extends CompanyState {
  final CompanyDetails details;

  const CompanySaved(this.details);

  @override
  List<Object> get props => [details];
}

class LogoUpdated extends CompanyState {
  final String logoPath;

  const LogoUpdated(this.logoPath);

  @override
  List<Object> get props => [logoPath];
}
