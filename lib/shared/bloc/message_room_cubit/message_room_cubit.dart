import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/message_room_cubit/message_room_state.dart';
import 'package:project4_flutter/features/messages/models/room.dart';

import '../../api/api_service.dart';
import '../../models/custom_result.dart';

class MessageRoomCubit extends Cubit<MessageRoomState> {
  String? userId;

  MessageRoomCubit() : super(MessageRoomNotAvailable());

  void loadUserRoom(String id) {
    userId = id;
    getRooms();
  }

  var apiService = ApiService();

  Future<List<Room>?> getRooms() async {
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
