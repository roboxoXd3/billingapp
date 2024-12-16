import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/company_details.dart';
import '../../repositories/company_repository.dart';

@injectable
class GetCompanyDetails implements UseCase<CompanyDetails, NoParams> {
  final CompanyRepository repository;

  GetCompanyDetails(this.repository);

  @override
  Future<Either<Failure, CompanyDetails>> call(NoParams params) {
    return repository.getCompanyDetails();
  }
}
