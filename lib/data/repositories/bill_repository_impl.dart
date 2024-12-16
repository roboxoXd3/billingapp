import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/bill_item_model.dart';

@Injectable(as: BillRepository)
class BillRepositoryImpl implements BillRepository {
  final DatabaseHelper databaseHelper;

  BillRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<BillItem>>> getBills() async {
    try {
      final billModels = await databaseHelper.getBills();
      final bills = billModels.map((model) => model.toEntity()).toList();
      return Right(bills);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BillItem>> saveBill(BillItem bill) async {
    try {
      final billModel = BillItemModel.fromEntity(bill);
      final savedBillModel = await databaseHelper.saveBill(billModel);
      return Right(savedBillModel.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBill(int id) async {
    try {
      await databaseHelper.deleteBill(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BillItem>> getBillById(int id) async {
    try {
      final bill = await databaseHelper.getBillById(id);
      if (bill == null) {
        return const Left(DatabaseFailure('Bill not found'));
      }
      return Right(bill.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> shareBill(BillItem bill) async {
    try {
      // Implement sharing logic here
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
