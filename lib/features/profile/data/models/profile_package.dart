import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:ailixir/features/profile/data/repos/profile_repo.dart';

class ProfilePackage {
  final ProfileRepo repo;
  final ProfileModel profile;
  const ProfilePackage({required this.profile, required this.repo});
}
