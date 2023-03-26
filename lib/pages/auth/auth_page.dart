import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/theme.dart';
import 'bloc/auth_bloc.dart';
import 'widgets/otp_page.dart';
import 'widgets/phone_page.dart';
import 'widgets/set_up_account.dart';

class AuthPage extends StatefulWidget {
  final int page;
  final String? uid;
  const AuthPage({
    Key? key,
    this.page = 0,
    this.uid,
  }) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController? _controller;

  int _pageIndex = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.page);
    _pageIndex = widget.page;
    super.initState();
  }

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
        bloc: context.watch<AuthBloc>(),
        listener: (_, state) {
          if (state is AuthLoggedInState) {
            _controller!.animateToPage(2,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn);
            setState(() {
              _pageIndex = 2;
            });
          }
        },
        builder: (context, state) {
          print('build $state');
          return Stack(
            children: [
              Container(
                height: screenSize.height,
                width: screenSize.width,
                color: Colors.white,
                child: PageView(
                  controller: _controller,
                  onPageChanged: onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PhonePage(numnberController: _phoneController),
                    OtpPage(
                      otpController: _otpController,
                      bloc: context.watch<AuthBloc>(),
                      phoneNumber: _phoneController.text,
                    ),
                    SetUpAccount(
                      firstnameController: _firstNameController,
                      lastnameController: _lastNameController,
                      emailController: _emailController,
                    ),
                  ],
                ),
              ),
              _buildFloatActionButton(state, context)
            ],
          );
        });
  }

  Positioned _buildFloatActionButton(AuthState state, BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          backgroundColor:
              state is AuthLoadingState ? Colors.grey[300] : CityTheme.cityblue,
          onPressed: state is AuthLoadingState
              ? null
              : () {
                  if (_phoneController.text.isNotEmpty &&
                      state is AuthInitialState &&
                      _pageIndex == 0) {
                    BlocProvider.of<AuthBloc>(context).add(
                        PhoneNumberVerificationEvent(
                            phone: '+234${_phoneController.text}'));
                    _controller!.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                    setState(() {
                      _pageIndex = 1;
                    });
                  } else if (state is AuthCodeSentState && _pageIndex == 1) {
                    BlocProvider.of<AuthBloc>(context).add(
                        PhoneAuthCodeVerificationEvent(
                            smsCode: _otpController.text,
                            verificationId: state.verificationId,
                            phone: '+234${_phoneController.text}'));
                    setState(() {
                      _pageIndex = 2;
                    });
                  } else if (_pageIndex == 2) {
                    BlocProvider.of<AuthBloc>(context).add(SignUpEvent(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      uid: state is AuthLoggedInState ? state.uid : widget.uid!,
                    ));
                  }
                },
          child: _pageIndex == 2
              ? const Icon(Icons.check_rounded)
              : const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  void onPageChanged(int value) {
    print('Me here');
    print(value);
    setState(() {
      _pageIndex = value;
    });
  }
}
