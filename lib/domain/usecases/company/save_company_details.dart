import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/company_details.dart';
import '../../repositories/company_repository.dart';

@injectable
class SaveCompanyDetails implements UseCase<void, CompanyDetails> {
  final CompanyRepository repository;

  SaveCompanyDetails(this.repository);

  @override
  Future<Either<Failure, void>> call(CompanyDetails details) {
    return repository.saveCompanyDetails(details);
  }
}
