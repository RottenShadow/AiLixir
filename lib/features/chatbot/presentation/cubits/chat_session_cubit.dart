import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/features/chatbot/data/models/chat_message_model.dart';
import 'package:ailixir/features/chatbot/data/repos/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_session_state.dart';

class ChatSessionCubit extends Cubit<ChatSessionState> {
  ChatSessionCubit() : super(ChatSessionInitial());

  final ChatRepo _repo = ChatRepo();
  late final int maxPage;
  String? sessionId;
  int currentPage = 1;
  Future<void> getSessionThread() async {
    emit(ChatSessionLoading());
    if (AppFeatureFlag.useFakeChatbot) {
      await Future.delayed(Duration(milliseconds: 22));
      emit(ChatSessionSuccess());
      return;
    }
    var res = await _repo.getUserThread();
    res.fold(
      (_) {
        emit(ChatSessionError());
      },
      (s) {
        sessionId = s;
        emit(ChatSessionSuccess());
      },
    );
  }

  Future<ChatMessageModel> sendMessage(String message) async {
    var res = await _repo.sendMessage(message);
    late ChatMessageModel response;
    if (AppFeatureFlag.useFakeChatbot) {
      await Future.delayed(Duration(milliseconds: 22));
      return ChatMessageModel(
        message: "Hello, how may I help you today?",
        isErr: false,
      );
    }
    res.fold(
      (e) {
        response = ChatMessageModel(isErr: true, message: e.message);
      },
      (s) {
        response = ChatMessageModel(isErr: false, message: s);
      },
    );
    return response;
  }
}
