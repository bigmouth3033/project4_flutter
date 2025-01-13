import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/api/user_api.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_state.dart';
import 'package:project4_flutter/shared/utils/token_storage.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserNotLogin()) {
    initializeUser(); // Call initializeUser when the cubit is created
  }

  var tokenStorage = TokenStorage();
  var userApi = UserApi();

  Future initializeUser() async {
    emit(UserLoading());
    try {
      var token = await tokenStorage.getToken();

      if (token != null && token.isNotEmpty) {
        var user = await userApi.getUserRequest(token);

        emit(UserSuccess(user!));
      } else {
        emit(UserNotLogin());
      }
    } catch (ex) {
      emit(UserError("User token expired"));
    }
  }

  Future<void> logout() async {
    await tokenStorage.deleteToken();
    emit(UserNotLogin());
  }
}
