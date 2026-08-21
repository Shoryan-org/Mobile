import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_state.dart';
import 'package:shoryan/features/auth/presentation/screens/create_new_password_screen.dart';

import 'package:shoryan/navigation/main_navigation_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final bool isPasswordRecovery;
  final String email;
  final String verificationId;

  const VerifyEmailScreen({
    super.key,
    this.isPasswordRecovery = false,
    required this.email,
    required this.verificationId,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  /// Tracks the current verification_id (may be refreshed by resend).
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
  }

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            (route) => false,
          );
        } else if (state is AuthVerifyPasswordResetSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => CreateNewPasswordScreen(
                email: widget.email,
                token: state.token,
              ),
            ),
          );
        } else if (state is AuthResendOtpSuccessWithId) {
          // Resend returned a fresh verification_id — update it.
          setState(() => _verificationId = state.verificationId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code resent successfully.')),
          );
        } else if (state is AuthResendOtpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code resent successfully.')),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SafeArea(
          child: Stack(
            children: [
              // Background Circle
              Positioned(
                top: 150,
                left: -50,
                right: -50,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: AppColors.veryLightPink.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Verify Email',
                            style: AppTextStyles.screenTitle.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Enter the 4-digit code sent to your email.',
                            style: AppTextStyles.screenSubtitle,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 60,
                                height: 60,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: AppTextStyles.screenTitle.copyWith(fontSize: 24),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  onChanged: (val) => _onChanged(val, index),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return TextButton(
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          if (widget.isPasswordRecovery) {
                                            context.read<AuthCubit>().resendPasswordResetOtp(widget.email);
                                          } else {
                                            context.read<AuthCubit>().resendRegistrationOtp(widget.email);
                                          }
                                        },
                                  child: Text(
                                    'Resend Code',
                                    style: AppTextStyles.navLabel.copyWith(
                                      color: AppColors.primaryRed,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            onPressed: () {
                              final code = _controllers.map((c) => c.text).join();
                              if (widget.isPasswordRecovery) {
                                context.read<AuthCubit>().verifyPasswordResetOtp(_verificationId, code);
                              } else {
                                context.read<AuthCubit>().verifyRegistrationEmail(_verificationId, code);
                              }
                            },
                            child: const Text('Verify', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
