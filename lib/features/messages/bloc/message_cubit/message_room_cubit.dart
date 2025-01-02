import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/features/messages/bloc/message_cubit/message_room_state.dart';
import 'package:project4_flutter/features/messages/models/room.dart';

import '../../../../shared/api/api_service.dart';
import '../../../../shared/models/custom_result.dart';

class MessageRoomCubit extends Cubit<MessageRoomState> {
  final String userId;

  MessageRoomCubit(this.userId) : super(MessageRoomLoading()) {
    getRooms(userId); // Call initializeUser when the cubit is created
  }

  var apiService = ApiService();

  Future<List<Room>?> getRooms(String userId) async {
    emit(MessageRoomLoading());
    try {
      Map<String, dynamic> params = {'userId': userId};
      var response =
          await apiService.get("/chat/get_chat_room", params: params);

      var customResult = CustomResult.fromJson(response);

      if (customResult.status == 200) {
        var rooms = (customResult.data as List).map((item) {
          return Room.fromJson(item);
        }).toList();

        emit(MessageRoomSuccess(rooms));

        print(rooms);

        return rooms;
      }
      return null;
    } catch (ex) {
      emit(MessageRoomError(ex.toString()));
      return null;
    }
  }
}
