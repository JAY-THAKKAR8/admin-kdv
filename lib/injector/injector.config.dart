// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../auth/repository/i_auth_repository.dart' as _i118;
import '../cubit/refresh_cubit.dart' as _i228;
import '../expenses/repository/expense_repository.dart' as _i173;
import '../expenses/repository/i_expense_repository.dart' as _i925;
import '../user/repository/i_user_repository.dart' as _i649;
import '../user/repository/user_repository.dart' as _i824;
import 'firebase_injectable_module.dart' as _i574;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    final firebaseAuthInjectableModule = _$FirebaseAuthInjectableModule();
    final firebaseStorageInjectableModule = _$FirebaseStorageInjectableModule();
    gh.factory<_i228.RefreshCubit>(() => _i228.RefreshCubit());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseInjectableModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseAuthInjectableModule.firestoreAuth);
    gh.lazySingleton<_i457.FirebaseStorage>(() => firebaseStorageInjectableModule.firestoreStorage);
    gh.factory<_i649.IUserRepository>(() => _i824.UserRepository(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i118.IAuthRepository>(() => _i118.AuthRepository(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.FirebaseFirestore>(),
        ));
    gh.factory<_i925.IExpenseRepository>(() => _i173.ExpenseRepository(gh<_i974.FirebaseFirestore>()));
    return this;
  }
}

class _$FirebaseInjectableModule extends _i574.FirebaseInjectableModule {}

class _$FirebaseAuthInjectableModule extends _i574.FirebaseAuthInjectableModule {}

class _$FirebaseStorageInjectableModule extends _i574.FirebaseStorageInjectableModule {}
