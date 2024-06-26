import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/user_model.dart';

import '../../../core/utils.dart';

final userProvider =
    StateProvider<UserModel?>((ref) => null); //State Provider is Mutable

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider
      .notifier); //notifier to access the methods of the authControllerProvider
  return authController.authStateChange;
});

//family used to pass params to StreamProvider
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message), //left is for error
      (userModel) => _ref
          .read(userProvider.notifier)
          .update((state) => userModel), //Success
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
