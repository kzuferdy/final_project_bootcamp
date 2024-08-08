part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final UserProfile? user;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfile? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, errorMessage];
}
