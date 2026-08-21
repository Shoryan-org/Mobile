import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/blood_type.dart';
import '../../models/urgency_level.dart';
import 'cubit/create_request_cubit.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _geocoding = Geocoding();

  BloodType _selectedBloodType = BloodType.oPositive;
  UrgencyLevel _selectedUrgency = UrgencyLevel.routine;
  int _noOfUnits = 1;
  String _notes = '';

  final _hospitalNameController = TextEditingController();
  final _hospitalAddressController = TextEditingController();

  bool _isResolvingAddress = false;

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blood Request', style: AppTextStyles.screenTitle),
      ),
      body: BlocConsumer<CreateRequestCubit, CreateRequestState>(
        listener: (context, state) {
          if (state is CreateRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request created successfully')),
            );
            // We do not pop here anymore; we show the success UI
          } else if (state is CreateRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CreateRequestSuccess) {
            return _buildSuccessView(state);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Blood Type', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<BloodType>(
                    value: _selectedBloodType,
                    items: BloodType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedBloodType = val);
                    },
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('Urgency', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<UrgencyLevel>(
                    value: _selectedUrgency,
                    items: UrgencyLevel.values.map((urgency) {
                      return DropdownMenuItem(
                        value: urgency,
                        child: Text(urgency.formLabel),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedUrgency = val);
                    },
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('Units Needed', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _noOfUnits.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onSaved: (val) => _noOfUnits = int.tryParse(val ?? '1') ?? 1,
                  ),
                  const SizedBox(height: 16),
                  const Text('Hospital Name', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _hospitalNameController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. City General Hospital'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Hospital Address', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _hospitalAddressController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. 123 Health St, City'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Notes', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onSaved: (val) => _notes = val ?? '',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (state is CreateRequestLoading || _isResolvingAddress)
                          ? null
                          : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();

                        setState(() => _isResolvingAddress = true);
                        double latitude;
                        double longitude;
                        try {
                          final locations = await _geocoding.locationFromAddress(
                            _hospitalAddressController.text,
                          );
                          if (locations.isEmpty) {
                            throw Exception('No location found for that address');
                          }
                          latitude = locations.first.latitude;
                          longitude = locations.first.longitude;
                        } catch (e) {
                          if (!mounted) return;
                          setState(() => _isResolvingAddress = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Could not locate that hospital address. Please check it and try again.',
                              ),
                            ),
                          );
                          return;
                        }
                        if (!mounted) return;
                        setState(() => _isResolvingAddress = false);

                        final payload = {
                          'blood_type': _selectedBloodType.label,
                          'urgency': _selectedUrgency.label,
                          'no_of_units': _noOfUnits,
                          'notes': _notes,
                          'hospital': {
                            'name': _hospitalNameController.text,
                            'address_text': _hospitalAddressController.text,
                            'latitude': latitude,
                            'longitude': longitude,
                          },
                        };
                        context.read<CreateRequestCubit>().create(payload);
                      },
                      child: (state is CreateRequestLoading || _isResolvingAddress)
                          ? const CircularProgressIndicator(color: AppColors.white)
                          : const Text('Submit Request'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessView(CreateRequestSuccess state) {
    // Sort donors by probability (highest to lowest)
    final donors = state.smartMatching?.data.availableUsers.toList() ?? [];
    donors.sort((a, b) => b.probability.compareTo(a.probability));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text('Blood Request Created Successfully!', style: AppTextStyles.screenTitle),
          const SizedBox(height: 24),
          if (state.nearestHospital != null) ...[
            const Text('Nearest Hospital (from your location)', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_hospital, color: AppColors.primaryRed),
                title: Text(state.nearestHospital!.name),
                subtitle: Text(
                  '${state.nearestHospital!.addressText ?? ''}\nDistance: ${(state.distanceInMeters! / 1000).toStringAsFixed(2)} km',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          const Text('Smart Matching: Available Donors', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          if (donors.isEmpty)
            const Text('No available donors found at this time.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final donor = donors[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Match: ${(donor.probability * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: donor.available ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                donor.available ? 'Available' : 'Unavailable',
                                style: TextStyle(
                                  color: donor.available ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Blood Group: ${donor.user.bloodGroup}', style: AppTextStyles.cardSubtitle),
                        Text('Age: ${donor.user.age} • Gender: ${donor.user.gender}', style: AppTextStyles.cardSubtitle),
                        Text('City: ${donor.user.city}', style: AppTextStyles.cardSubtitle),
                        Text('Donation Center: ${donor.user.donationCenter}', style: AppTextStyles.cardSubtitle),
                        Text('Total Donations: ${donor.user.totalDonations}', style: AppTextStyles.cardSubtitle),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}