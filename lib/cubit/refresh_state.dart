part of 'refresh_cubit.dart';

sealed class RefreshState extends Equatable {
  const RefreshState();

  @override
  List<Object> get props => [];
}

final class UserRefreshInitial extends RefreshState {}

final class ModifyUser extends RefreshState {
  const ModifyUser({required this.user, required this.action});

  final UserModel user;
  final UserAction action;

  @override
  List<Object> get props => [user, action];
}

final class ModifyExpanse extends RefreshState {
  const ModifyExpanse({required this.expanse, required this.action});

  final ExpenseModel expanse;
  final ExpanseAction action;

  @override
  List<Object> get props => [expanse, action];
}

final class ModifyMaintenance extends RefreshState {
  const ModifyMaintenance({required this.maintenance, required this.action});

  final MaintenanceModel maintenance;
  final MaintenanceAction action;

  @override
  List<Object> get props => [maintenance, action];
}
