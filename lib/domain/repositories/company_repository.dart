import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/company_details.dart';

abstract class CompanyRepository {
  Future<Either<Failure, CompanyDetails>> getCompanyDetails();
  Future<Either<Failure, void>> saveCompanyDetails(CompanyDetails details);
  Future<Either<Failure, void>> updateLogo(String logoPath);
  Future<Either<Failure, String?>> getLogo();
}
