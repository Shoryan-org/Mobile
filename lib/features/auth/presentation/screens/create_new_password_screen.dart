import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_state.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_card.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shoryan/features/auth/presentation/screens/sign_in_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successful!')));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Create New Password',
                  style: AppTextStyles.screenTitle.copyWith(
                    color: AppColors.primaryRed,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your new password must be different from\nprevious ones.',
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: 32),
                AuthCard(
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'New Password',
                        hint: 'Enter new password',
                        controller: _newPasswordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        label: 'Confirm Password',
                        hint: 'Re-enter password',
                        controller: _confirmPasswordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_newPasswordController.text != _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                            return;
                          }
                          context.read<AuthCubit>().resetPassword(
                            email: widget.email,
                            token: widget.token,
                            password: _newPasswordController.text,
                            passwordConfirmation: _confirmPasswordController.text,
                          );
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
