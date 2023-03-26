import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<PhoneNumberVerificationEvent>((event, emit) async {
      emit(AuthLoadingState());
      await AuthService.instance.verifyPhoneSendOtp(event.phone,
          onVerificationCompleted: (credential) {
        add(CompleteAuthEvent(credential: credential));
      }, onVerificationFailed: (error) {
        print("error");
        add(ErrorOccurredEvent(error: error.toString()));
      }, onCodeSent: (verificationId, tokenCode) {
        print("code sent $verificationId");
        add(CodeSentEvent(
            verificationId: verificationId, tokenCode: tokenCode!));
      }, onCodeAutoRetrievalTimeout: (verificationId) {
        print('timeout $verificationId');
      });
    });
    on<PhoneAuthCodeVerificationEvent>((event, emit) async {
      final uid = await AuthService.instance
          .verifyAndLogin(event.verificationId, event.smsCode, event.phone);
      emit(AuthLoggedInState(uid: uid));
    });
    on<CodeSentEvent>((event, emit) {
      emit(AuthCodeSentState(
        verificationId: event.verificationId,
        tokenCode: event.tokenCode,
      ));
    });
  }
}
