import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/model/user/user_cache/cached_user_data_model.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_token_user_response.dart';

class LocalAuthDataSource {
  final SecureStorageService secureStorage;

  LocalAuthDataSource({required this.secureStorage});

  Future<void> saveAllUserData({
    required AuthTokenUserResponse authTokenUserResponse,
  }) async {
    await saveUserData(
      id: authTokenUserResponse.user.id,
      name: authTokenUserResponse.user.name,
      email: authTokenUserResponse.user.email,
      role: authTokenUserResponse.user.role,
      avatar: authTokenUserResponse.user.avatar,
    );
    await updateUserAccessToken(token: authTokenUserResponse.token);
    // await saveUserTokens(
    //   token: authTokenUserResponse.token,
    //   // refreshToken: authTokenUserResponse.refreshToken,
    // );
  }

  Future<void> saveUserData({
    int? id,
    String? name,
    String? email,
    String? role,
    String? avatar,
  }) async {
    final current = CachedUserDataModel.fromCache();
    final updated = CachedUserDataModel(
      id: id ?? current.id,
      name: name ?? current.name,
      email: email ?? current.email,
      role: role ?? current.role,
      avatar: avatar ?? current.avatar,
    );

    for (final entry in updated.toMap().entries) {
      if (entry.value is String) {
        await SharedPreferencesService.setString(
          key: entry.key,
          value: entry.value,
        );
      } else if (entry.value is int) {
        await SharedPreferencesService.setInt(
          key: entry.key,
          value: entry.value,
        );
      }
    }
  }

  Future<String?> getUserToken() async {
    return await secureStorage.readValue(key: AppConstants.accessTokenKey);
  }

  // Future<String?> getUserRefreshToken() async {
  //   return await secureStorage.readValue(
  //     key: AppConstants.refreshAccessTokenKey,
  //   );
  // }

  // Future<void> saveUserTokens({
  //   required String token,
  //   required String refreshToken,
  // }) async {
  //   await secureStorage.writeValue(
  //     key: AppConstants.accessTokenKey,
  //     value: token,
  //   );
  //   await secureStorage.writeValue(
  //     key: AppConstants.refreshAccessTokenKey,
  //     value: refreshToken,
  //   );
  // }

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
