import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/bill/delete_bill.dart';
import '../../../domain/usecases/bill/get_bills.dart';
import '../../../domain/usecases/bill/save_bill.dart';
import 'bill_event.dart';
import 'bill_state.dart';

@injectable
class BillBloc extends Bloc<BillEvent, BillState> {
  final GetBills _getBills;
  final SaveBill _saveBill;
  final DeleteBill _deleteBill;

  BillBloc(
    this._getBills,
    this._saveBill,
    this._deleteBill,
  ) : super(BillInitial()) {
    on<LoadBills>(_onLoadBills);
    on<SaveBillEvent>(_onSaveBill);
    on<DeleteBillEvent>(_onDeleteBill);
  }

  Future<void> _onLoadBills(LoadBills event, Emitter<BillState> emit) async {
    emit(BillLoading());
    final result = await _getBills(NoParams());
    result.fold(
      (failure) => emit(BillError(failure.message)),
      (bills) => emit(BillsLoaded(bills)),
    );
  }

  Future<void> _onSaveBill(SaveBillEvent event, Emitter<BillState> emit) async {
    emit(BillLoading());
    final result = await _saveBill(event.bill);
    result.fold(
      (failure) => emit(BillError(failure.message)),
      (savedBill) {
        emit(BillSaved(savedBill));
        add(LoadBills()); // Reload bills after saving
      },
    );
  }

  Future<void> _onDeleteBill(
      DeleteBillEvent event, Emitter<BillState> emit) async {
    emit(BillLoading());
    final result = await _deleteBill(event.id);
    result.fold(
      (failure) => emit(BillError(failure.message)),
      (_) {
        emit(BillDeleted());
        add(LoadBills()); // Reload bills after deletion
      },
    );
  }
}
