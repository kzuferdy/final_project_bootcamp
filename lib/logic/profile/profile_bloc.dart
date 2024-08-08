import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/profile_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileBloc() : super(const ProfileState()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(event.userId).get();
      if (doc.exists) {
        final userProfile = UserProfile.fromFirestore(doc);
        emit(state.copyWith(user: userProfile, isLoading: false));
      } else {
        emit(state.copyWith(errorMessage: 'User not found', isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
