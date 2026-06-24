part of 'history_tab_cubit.dart';

enum HistoryTab { generation, docking, md, drugRepurposing }

@immutable
class HistoryTabState {
  final HistoryTab selectedTab;

  const HistoryTabState({required this.selectedTab});
}
