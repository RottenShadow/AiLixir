import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/constants/app_strings.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';

class CachedUserDataModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String avatar;

  CachedUserDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
  });

  /// Factory constructor to build from SharedPreferences
  factory CachedUserDataModel.fromCache() {
    return CachedUserDataModel(
      id: SharedPreferencesService.getInt(key: AppConstants.userIdKey),
      name:
          SharedPreferencesService.getString(key: AppConstants.userNameKey) ??
          AppStrings.userDefaultName,
      email:
          SharedPreferencesService.getString(key: AppConstants.userEmailKey) ??
          AppStrings.userDefaultEmail,
      role:
          SharedPreferencesService.getString(key: AppConstants.userRoleKey) ??
          AppStrings.userDefaultRole,
      avatar:
          SharedPreferencesService.getString(key: AppConstants.userImageKey) ??
          '',
    );
  }

  Map<String, dynamic> toMap() => {
    AppConstants.userIdKey: id,
    AppConstants.userNameKey: name,
    AppConstants.userEmailKey: email,
    AppConstants.userRoleKey: role,
    AppConstants.userImageKey: avatar,
  };
}
