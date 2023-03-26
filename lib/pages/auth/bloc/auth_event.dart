part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  // final String phone;

  const SignUpEvent({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.phone,
  });
}

class PhoneNumberVerificationEvent extends AuthEvent {
  final String phone;

  const PhoneNumberVerificationEvent({
    required this.phone,
  });
}

class PhoneAuthCodeVerificationEvent extends AuthEvent {
  final String phone;
  final String verificationId;
  final String smsCode;

  const PhoneAuthCodeVerificationEvent({
    required this.phone,
    required this.verificationId,
    required this.smsCode,
  });
}

class CompleteAuthEvent extends AuthEvent {
  final AuthCredential credential;

  const CompleteAuthEvent({
    required this.credential,
  });
}

class ErrorOccurredEvent extends AuthEvent {
  final String error;

  const ErrorOccurredEvent({
    required this.error,
  });
}

class CodeSentEvent extends AuthEvent {
  final int tokenCode;
  final String verificationId;

  const CodeSentEvent({
    required this.tokenCode,
    required this.verificationId,
  });
}
