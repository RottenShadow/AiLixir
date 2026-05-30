import 'package:ailixir/features/chatbot/data/models/chat_message_model.dart';
import 'package:ailixir/features/chatbot/data/repos/chat_repo.dart';
import 'package:ailixir/features/scientists/data/factories/scientist_factory.dart';
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
    var res = await _repo.getUserThread("");
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
    var res = await _repo.sendMessage("", message);
    late ChatMessageModel response;
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

  Future<void> getTestScientists() async {
    emit(ChatSessionLoading());
    var res = await _repo.getTestThreads("");
    res.fold(
      (_) {
        emit(ChatSessionError());
      },
      (jsonData) {
        sessionId = jsonData.thread_id;
        emit(ChatSessionSuccess());
      },
    );
  }
}
