import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/constants/app_strings.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';

class CachedUserDataModel {
  final String id;
  final String displayName;
  final String userName;
  final String profilePicture;
  final String bio;

  CachedUserDataModel({
    required this.id,
    required this.displayName,
    required this.userName,
    required this.profilePicture,
    required this.bio,
  });

  /// Factory constructor to build from SharedPreferences
  factory CachedUserDataModel.fromCache() {
    return CachedUserDataModel(
      id:
          SharedPreferencesService.getString(key: AppConstants.userIdKey) ??
          AppStrings.userDefaultId,
      displayName:
          SharedPreferencesService.getString(
            key: AppConstants.userDisplayNameKey,
          ) ??
          AppStrings.userDefaultDisplayName,
      userName:
          SharedPreferencesService.getString(
            key: AppConstants.userUserNameKey,
          ) ??
          AppStrings.userDefaultUsername,
      bio:
          SharedPreferencesService.getString(key: AppConstants.userBioKey) ??
          AppStrings.userDefaultBio,
      profilePicture:
          SharedPreferencesService.getString(key: AppConstants.userImageKey) ??
          '',
    );
  }

  Map<String, String> toMap() => {
    AppConstants.userIdKey: id,
    AppConstants.userDisplayNameKey: displayName,
    AppConstants.userUserNameKey: userName,
    AppConstants.userBioKey: bio,
    AppConstants.userImageKey: profilePicture,
  };
}
