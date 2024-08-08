part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String userId;

  const FetchUserProfile(this.userId);

  @override
  List<Object> get props => [userId];
}
