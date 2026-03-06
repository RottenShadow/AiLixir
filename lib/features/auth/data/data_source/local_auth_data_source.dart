import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/model/user/user_cache/cached_user_data_model.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';
import 'package:ailixir/features/auth/data/model/auth_signin_response_model.dart';

class LocalAuthDataSource {
  final SecureStorageService secureStorage;

  LocalAuthDataSource({required this.secureStorage});

  Future<void> saveAllUserData({
    required AuthLoginSuccessModel authLoginSuccessModel,
  }) async {
    await saveUserData(
      id: authLoginSuccessModel.user.id,
      displayName: authLoginSuccessModel.user.displayName,
      userName: authLoginSuccessModel.user.username,
      profilePicture: authLoginSuccessModel.user.avatar,
      bio: authLoginSuccessModel.user.bio,
    );
    await saveUserTokens(
      token: authLoginSuccessModel.token,
      refreshToken: authLoginSuccessModel.refreshToken,
    );
  }

  Future<void> saveUserData({
    String? id,
    String? displayName,
    String? userName,
    String? profilePicture,
    String? bio,
  }) async {
    final current = CachedUserDataModel.fromCache();
    final updated = CachedUserDataModel(
      id: id ?? current.id,
      displayName: displayName ?? current.displayName,
      userName: userName ?? current.userName,
      bio: bio ?? current.bio,
      profilePicture: profilePicture ?? current.profilePicture,
    );

    for (final entry in updated.toMap().entries) {
      await SharedPreferencesService.setString(
        key: entry.key,
        value: entry.value,
      );
    }
  }

  Future<String?> getUserToken() async {
    return await secureStorage.readValue(key: AppConstants.accessTokenKey);
  }

  Future<String?> getUserRefreshToken() async {
    return await secureStorage.readValue(
      key: AppConstants.refreshAccessTokenKey,
    );
  }

  Future<void> saveUserTokens({
    required String token,
    required String refreshToken,
  }) async {
    await secureStorage.writeValue(
      key: AppConstants.accessTokenKey,
      value: token,
    );
    await secureStorage.writeValue(
      key: AppConstants.refreshAccessTokenKey,
      value: refreshToken,
    );
  }

  Future<void> updateUserAccessToken({required String token}) async {
    await secureStorage.writeValue(
      key: AppConstants.accessTokenKey,
      value: token,
    );
  }

  Future<void> clearUserTokensAndData() async {
    await secureStorage.deleteAll();
    await SharedPreferencesService.deleteAllUserData();
  }
}
