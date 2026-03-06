import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';

part 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit() : super(Update());

  String currentLanguage =
      SharedPreferencesService.getString(key: AppConstants.localizeKey) ?? 'en';

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    await SharedPreferencesService.setString(
      key: AppConstants.localizeKey,
      value: langCode,
    );
    currentLanguage = langCode;
    emit(Update());
  }
}
