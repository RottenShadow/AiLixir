part of 'chat_session_cubit.dart';

@immutable
sealed class ChatSessionState {}

class ChatSessionInitial extends ChatSessionState {}

class ChatSessionLoading extends ChatSessionState {}

class ChatSessionError extends ChatSessionState {}

class ChatSessionSuccess extends ChatSessionState {}

class ChatSessionSearch extends ChatSessionState {}
