part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSignUpErrorState extends AuthState {
  final String message;

  const AuthSignUpErrorState({
    required this.message,
  });
}

class AuthLoggedInState extends AuthState {
  final String uid;

  const AuthLoggedInState({
    required this.uid,
  });
}

class AuthAutoLoggedInState extends AuthLoggedInState {
  const AuthAutoLoggedInState(String uid) : super(uid: uid);
}

class AuthCodeSentState extends AuthState {
  final String verificationId;
  final int tokenCode;

  const AuthCodeSentState({
    required this.verificationId,
    required this.tokenCode,
  });
}
