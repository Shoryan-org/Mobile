import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/requests/request_card.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'cubit/donor_blood_requests_cubit.dart';
import 'cubit/requester_blood_requests_cubit.dart';
import 'cubit/blood_request_action_cubit.dart';
import 'create_request_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool _showAccepted = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final isDonor = context.read<AuthCubit>().isDonor;
    if (isDonor) {
      context.read<DonorBloodRequestsCubit>().fetchDonorRequests();
    } else {
      context.read<RequesterBloodRequestsCubit>().fetchMyRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDonor = context.watch<AuthCubit>().isDonor;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        toolbarHeight: 76,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isDonor ? 'Blood Requests' : 'My Blood Requests', style: AppTextStyles.screenTitle),
          ],
        ),
        actions: [
          if (!isDonor)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRequestScreen())).then((_) {
                    _loadData();
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ),
            ),
        ],
      ),
      body: BlocListener<BloodRequestActionCubit, BloodRequestActionState>(
        listener: (context, state) {
          if (state is BloodRequestActionSuccess) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request ${state.action}ed successfully!')));
             context.read<DonorBloodRequestsCubit>().fetchDonorRequests();
          } else if (state is BloodRequestActionError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: isDonor ? _buildDonorView() : _buildRequesterView(),
      ),
    );
  }

  Widget _buildDonorView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('Compatible'),
                  selected: !_showAccepted,
                  onSelected: (val) {
                    if (val) setState(() => _showAccepted = false);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Accepted'),
                  selected: _showAccepted,
                  onSelected: (val) {
                    if (val) setState(() => _showAccepted = true);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<DonorBloodRequestsCubit, DonorBloodRequestsState>(
            builder: (context, state) {
              if (state is DonorBloodRequestsLoading || state is DonorBloodRequestsInitial) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
              } else if (state is DonorBloodRequestsLoaded) {
                final list = _showAccepted ? state.acceptedRequests : state.compatibleRequests;
                if (list.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final request = list[index];
                    return RequestCard(
                      request: request,
                      isDonorView: true,
                      isAccepted: _showAccepted,
                      onAccept: () {
                        context.read<BloodRequestActionCubit>().accept(request.id);
                      },
                      onDismiss: () {
                        context.read<BloodRequestActionCubit>().reject(request.id);
                      },
                    );
                  },
                );
              } else if (state is DonorBloodRequestsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequesterView() {
    return BlocBuilder<RequesterBloodRequestsCubit, RequesterBloodRequestsState>(
      builder: (context, state) {
        if (state is RequesterBloodRequestsLoading || state is RequesterBloodRequestsInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
        } else if (state is RequesterBloodRequestsLoaded) {
          if (state.requests.isEmpty) {
            return const Center(child: Text('You have not created any requests yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return RequestCard(
                request: request,
                isDonorView: false,
                isAccepted: false,
              );
            },
          );
        } else if (state is RequesterBloodRequestsError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}