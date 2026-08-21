import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_state.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_card.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shoryan/features/auth/presentation/screens/verify_email_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VerifyEmailScreen(
                isPasswordRecovery: true,
                email: state.email,
                verificationId: state.verificationId,
              ),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      'Shoryan',
                      style: AppTextStyles.screenTitle.copyWith(
                        color: AppColors.primaryRed,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.veryLightPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    color: AppColors.primaryRed,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Forgot Password',
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your registered email address below.\nWe'll send you a secure recovery code to\nreset your password.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: 32),
                AuthCard(
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Email Address',
                        hint: 'donor@example.com',
                        controller: _emailController,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.mail_outline, color: AppColors.textSecondary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ElevatedButton(
                              onPressed: () {
                                context.read<AuthCubit>().forgotPassword(_emailController.text);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Send Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: RichText(
                    text: TextSpan(
                      text: "Remember your password? ",
                      style: AppTextStyles.cardSubtitle.copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: AppTextStyles.cardSubtitle.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
