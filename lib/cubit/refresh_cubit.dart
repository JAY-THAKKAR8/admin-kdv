import 'package:admin_kdv/enums/enum_file.dart';
import 'package:admin_kdv/expenses/model/expense_model.dart';
import 'package:admin_kdv/maintenance/model/maintenance_model.dart';
import 'package:admin_kdv/user/model/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'refresh_state.dart';

@injectable
class RefreshCubit extends Cubit<RefreshState> {
  RefreshCubit() : super(UserRefreshInitial());

  void modifyUser(UserModel? user, UserAction action) {
    emit(ModifyUser(user: user ?? const UserModel(), action: action));
  }

  void modifyExpanse(ExpenseModel? expanse, ExpanseAction action) {
    emit(ModifyExpanse(expanse: expanse ?? const ExpenseModel(), action: action));
  }

  void modifyMaintenance(MaintenanceModel? maintenance, MaintenanceAction action) {
    emit(ModifyMaintenance(maintenance: maintenance ?? const MaintenanceModel(), action: action));
  }
}
