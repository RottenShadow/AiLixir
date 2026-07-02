import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'history_tab_state.dart';

class HistoryTabCubit extends Cubit<HistoryTabState> {
  HistoryTabCubit() : super(HistoryTabState(selectedTab: HistoryTab.generation));

  void selectTab(HistoryTab tab) {
    if (state.selectedTab != tab) {
      emit(HistoryTabState(selectedTab: tab));
    }
  }
}
