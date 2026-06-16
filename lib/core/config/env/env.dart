import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_CLIENT_ID')
  static const String googleClientId = _Env.googleClientId;

  @EnviedField(varName: 'GOOGLE_CLIENT_SECRET')
  static const String googleClientSecret = _Env.googleClientSecret;
}
