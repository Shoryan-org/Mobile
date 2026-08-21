import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_state.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_card.dart';
import 'package:shoryan/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:shoryan/features/auth/presentation/screens/verify_email_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isDonor = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _selectedBloodType = 'A+';

  bool _obscurePassword = true;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthVerifyEmailSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VerifyEmailScreen(
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
                const SizedBox(height: 16),
                Text(
                  'Create Account',
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join Shoryan to connect with blood donors\nand requesters in your area.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: 32),
                AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.veryLightPink,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isDonor = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _isDonor ? AppColors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: _isDonor
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Donor',
                                    style: AppTextStyles.cardTitle.copyWith(
                                      color: _isDonor ? AppColors.primaryRed : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isDonor = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !_isDonor ? AppColors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: !_isDonor
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Requester',
                                    style: AppTextStyles.cardTitle.copyWith(
                                      color: !_isDonor ? AppColors.primaryRed : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      AuthTextField(label: 'Full Name', controller: _nameController),
                      const SizedBox(height: 24),
                      AuthTextField(label: 'Email Address', controller: _emailController),
                      const SizedBox(height: 24),
                      AuthTextField(label: 'Phone Number', controller: _phoneController),
                      const SizedBox(height: 24),
                      AuthTextField(
                        label: 'Address / Location',
                        controller: _addressController,
                        suffixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 32),
                      Text('Select Blood Type', style: AppTextStyles.cardSubtitle.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _bloodTypes.map((type) {
                          final isSelected = _selectedBloodType == type;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedBloodType = type),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryRed : AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryRed : AppColors.border,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                type,
                                style: AppTextStyles.cardTitle.copyWith(
                                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      AuthTextField(
                        label: 'Password',
                        controller: _passwordController,
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
                        controller: _confirmController,
                        obscureText: _obscurePassword,
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
                                if (_passwordController.text != _confirmController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                                  return;
                                }
                                context.read<AuthCubit>().createAccount(
                                  fullName: _nameController.text,
                                  email: _emailController.text,
                                  phoneNumber: _phoneController.text,
                                  address: _addressController.text,
                                  bloodType: _selectedBloodType,
                                  password: _passwordController.text,
                                  passwordConfirmation: _confirmController.text,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: AppTextStyles.cardSubtitle.copyWith(color: AppColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: AppTextStyles.cardSubtitle.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
