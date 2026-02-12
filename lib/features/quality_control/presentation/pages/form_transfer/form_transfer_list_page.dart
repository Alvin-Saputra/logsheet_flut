import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/form_transfer/form_transfer_header_model.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/form_transfer/form_transfer_input_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/form_transfer/form_transfer_detail_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/form_transfer/form_transfer_provider.dart';
import 'package:provider/provider.dart';

class FormTransferListPage extends StatefulWidget {
  const FormTransferListPage({super.key});

  @override
  State<FormTransferListPage> createState() => _FormTransferListPageState();
}

class _FormTransferListPageState extends State<FormTransferListPage> {
  final TextEditingController _dateController = TextEditingController();
  final StorageService _storageService = StorageService();
  DateTime? _selectedDate;
  String? _selectedStatus = "All";
  final List<String> _statusOptions = [
    "All",
    "Submitted",
    "In Progress",
    "Approved",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final token = await _storageService.readSessionToken();
    if (token != null && mounted) {
      await context.read<FormTransferProvider>().loadTransfers('Bearer $token');
    }
  }

  Future<void> _onRefresh() async {
    final token = await _storageService.readSessionToken();
    if (token != null && mounted) {
      await context.read<FormTransferProvider>().loadTransfers(
        'Bearer $token',
        transactionDate: _getTransactionDateQuery(),
        status: _getStatusQuery(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Transfer'),
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToInput,
        label: const Text('Tambah Form Transfer'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: Consumer<FormTransferProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return _buildErrorWidget(provider.error!);
              }

              if (provider.transfers.isEmpty) {
                return _buildEmptyWidget();
              }

              return _buildTransfersList(provider.transfers);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Pilih Tanggal',
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () => _pickDate(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String?>(
              isExpanded: true,
              value: _selectedStatus,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                hintText: "Status",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.filter_list),
              ),
              items:
                  _statusOptions
                      .map(
                        (status) => DropdownMenuItem<String?>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _onSearch,
            icon: const Icon(Icons.search),
            label: const Text('Cari'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada data form transfer',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tarik ke bawah untuk menyegarkan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfersList(List<FormTransferHeaderModel> transfers) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: transfers.length,
        itemBuilder: (context, index) {
          final transfer = transfers[index];
          return _buildTransferCard(transfer);
        },
      ),
    );
  }

  Widget _buildTransferCard(FormTransferHeaderModel transfer) {
    return InkWell(
      onTap: () => _navigateToDetail(transfer),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      transfer.jsonId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(transfer),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(transfer.jsonTransactionDate),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dari: ${transfer.jsonFromDept ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.arrow_back, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ke: ${transfer.jsonToDept ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Entry by: ${transfer.jsonEntryBy ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildStatusChip(FormTransferHeaderModel transfer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(transfer),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(transfer),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusText(FormTransferHeaderModel transfer) {
    // 2-step approval: Lead (prepared) -> Manager (approved)
    // Check approval hierarchy: Manager > Lead
    if (transfer.jsonApprovedStatus?.toLowerCase() == 'approved') {
      return 'Approved';
    }
    if (transfer.jsonPreparedStatus?.toLowerCase() == 'approved') {
      return 'Lead Approved';
    }

    // Check for any rejection
    if (transfer.jsonApprovedStatus?.toLowerCase() == 'rejected' ||
        transfer.jsonPreparedStatus?.toLowerCase() == 'rejected') {
      return 'Rejected';
    }

    // Check for in-progress/pending (any status submitted but not approved/rejected)
    if (transfer.jsonPreparedStatus?.toLowerCase() == 'submitted' ||
        transfer.jsonApprovedStatus?.toLowerCase() == 'submitted') {
      return 'In Progress';
    }

    // Default to Draft/Submitted
    return 'Submitted';
  }

  Color _getStatusColor(FormTransferHeaderModel transfer) {
    // 2-step approval: Lead (prepared) → Manager (approved)
    // Approved (manager) → Green
    if (transfer.jsonApprovedStatus?.toLowerCase() == 'approved') {
      return Colors.green;
    }

    // Lead approved only → Light Green
    if (transfer.jsonPreparedStatus?.toLowerCase() == 'approved') {
      return Colors.green[300]!;
    }

    // Rejected → Red
    if (transfer.jsonApprovedStatus?.toLowerCase() == 'rejected' ||
        transfer.jsonPreparedStatus?.toLowerCase() == 'rejected') {
      return Colors.red;
    }

    // Pending/In Progress → Orange
    if (transfer.jsonPreparedStatus?.toLowerCase() == 'submitted' ||
        transfer.jsonApprovedStatus?.toLowerCase() == 'submitted') {
      return Colors.orange;
    }

    // Submitted/Draft → Grey
    return Colors.grey;
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '-';
    }
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  void _onSearch() {
    final transactionDate = _parseDateTimeForQuery(_dateController.text);

    log('Searching form transfers for date: $transactionDate');

    _fetchTransfers();
  }

  Future<void> _fetchTransfers() async {
    final token = await _storageService.readSessionToken();
    if (token != null && mounted) {
      await context.read<FormTransferProvider>().loadTransfers(
        'Bearer $token',
        transactionDate: _getTransactionDateQuery(),
        status: _getStatusQuery(),
      );
    }
  }

  String? _getTransactionDateQuery() {
    if (_selectedDate == null) return null;
    return DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  String? _getStatusQuery() {
    if (_selectedStatus == null || _selectedStatus == 'All') {
      return null;
    }
    return _selectedStatus;
  }

  String? _parseDateTimeForQuery(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) return null;

    try {
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);
      final outputFormat = DateFormat('yyyy-MM-dd');
      return outputFormat.format(dateTime);
    } catch (e) {
      log('Error parsing date: $e');
      return null;
    }
  }

  void _navigateToInput() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormTransferInputPage()),
    ).then((_) {
      _onRefresh();
    });
  }

  void _navigateToDetail(FormTransferHeaderModel transfer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                FormTransferDetailPage(item: transfer, isDisplayed: true),
      ),
    ).then((_) {
      _onRefresh();
    });
  }
}
