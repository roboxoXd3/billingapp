import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/company_details.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/company_details_model.dart';

@Injectable(as: CompanyRepository)
class CompanyRepositoryImpl implements CompanyRepository {
  final DatabaseHelper databaseHelper;

  CompanyRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, CompanyDetails>> getCompanyDetails() async {
    try {
      final details = await databaseHelper.getCompanyDetails();
      if (details == null) {
        return const Left(DatabaseFailure('Company details not found'));
      }
      return Right(details);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveCompanyDetails(
      CompanyDetails details) async {
    try {
      final model = CompanyDetailsModel.fromEntity(details);
      await databaseHelper.saveCompanyDetails(model);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateLogo(String logoPath) async {
    try {
      final details = await databaseHelper.getCompanyDetails();
      if (details == null) {
        return const Left(DatabaseFailure('Company details not found'));
      }
      final updatedDetails = details.copyWith(logo: logoPath);
      await databaseHelper.saveCompanyDetails(updatedDetails);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getLogo() async {
    try {
      final details = await databaseHelper.getCompanyDetails();
      return Right(details?.logo);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
