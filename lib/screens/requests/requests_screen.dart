import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/blood_request_repository.dart';
import '../../data/repositories/mock_blood_request_repository.dart';
import '../../models/blood_request.dart';
import '../../models/request_filter.dart';
import '../../widgets/requests/request_card.dart';
import '../../widgets/requests_screen/filter_chip_row.dart';
import '../../widgets/requests_screen/search_bar_widget.dart';

class RequestsScreen extends StatefulWidget {
  final BloodRequestRepository repository;

  RequestsScreen({super.key, BloodRequestRepository? repository})
      : repository = repository ?? MockBloodRequestRepository();

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  RequestFilter _filter = RequestFilter.all;
  List<BloodRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_loadRequests);
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.removeListener(_loadRequests);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final requests = await widget.repository.getRequests(
      filter: _filter,
      query: _searchController.text,
    );
    if (!mounted) return;
    setState(() {
      _requests = requests;
      _isLoading = false;
    });
  }

  void _onFilterSelected(RequestFilter filter) {
    setState(() => _filter = filter);
    _loadRequests();
  }

  void _dismissRequest(String id) {
    setState(() => _requests.removeWhere((r) => r.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        toolbarHeight: 76,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Requests', style: AppTextStyles.screenTitle),
            const SizedBox(height: 2),
            Text(
              '${_requests.length} open near Nasr City',
              style: AppTextStyles.screenSubtitle,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {},
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: RequestsSearchBar(
              controller: _searchController,
              onFilterTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FilterChipRow(
              selected: _filter,
              onSelected: _onFilterSelected,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primaryRed))
                : _requests.isEmpty
                ? const Center(
              child: Text(
                'No requests match your filters.',
                style: AppTextStyles.cardSubtitle,
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return RequestCard(
                  request: request,
                  onAccept: () {},
                  onDismiss: () => _dismissRequest(request.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}