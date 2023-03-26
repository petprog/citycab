import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Create a singleton AuthService
class AuthService {
  AuthService._();

  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // write verifyPhoneSendOtp
  Future<void> verifyPhoneSendOtp(
    String phoneNumber, {
    void Function(PhoneAuthCredential)? onVerificationCompleted,
    void Function(FirebaseAuthException)? onVerificationFailed,
    void Function(String, int?)? onCodeSent,
    void Function(String)? onCodeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: onVerificationCompleted!,
        verificationFailed: onVerificationFailed!,
        codeSent: onCodeSent!,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout!,
      );
    } catch (e) {
      print(e);
    }
  }

  //write verifyAndLoginWithPhone
  Future<String> verifyAndLogin(
      String verificationId, String smsCode, String phone) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final authCredential = await _auth.signInWithCredential(credential);

      if (authCredential.user != null) {
        final uid = authCredential.user!.uid;
        final userSnap =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (!userSnap.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'uid': uid,
            'phone': phone,
          });
        }
        return uid;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // getCredential

  Future<String> getCredential(PhoneAuthCredential credentail) async {
    final authCredential = await _auth.signInWithCredential(credentail);
    return authCredential.user!.uid;
  }

  // Future<void> verifyPhoneSendOtp(String phoneNumber) async {
  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         print(verificationId);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         print(verificationId);
  //       },
  //       timeout: const Duration(seconds: 60),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

}
