import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:logsheet_app/core/utils/parser_utils.dart'; // Uncomment jika masih butuh
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractionationApprovalDetailPage extends StatefulWidget {
  const DailyProductionFractionationApprovalDetailPage({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });
  final List<DailyProductionFractionationEntity> reportEntities;
  final String reportIdentifier;

  @override
  State<DailyProductionFractionationApprovalDetailPage> createState() =>
      _DailyProductionFractionationApprovalDetailPageState();
}

class _DailyProductionFractionationApprovalDetailPageState
    extends State<DailyProductionFractionationApprovalDetailPage> {
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) =>
      date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';

  @override
  Widget build(BuildContext context) {
    // Kita urutkan data berdasarkan transaction date (waktu awal ke akhir)
    final sortedEntities = List<DailyProductionFractionationEntity>.from(
      widget.reportEntities,
    )..sort((a, b) {
      if (a.transactionDate == null) return 1;
      if (b.transactionDate == null) return -1;
      return a.transactionDate!.compareTo(b.transactionDate!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail: ${widget.reportIdentifier}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: sortedEntities.length,
        itemBuilder: (context, index) {
          final report = sortedEntities[index];
          
          // Mengambil info user yang login dari provider
          final currentUser = context.watch<UserProvider>().currentUser;
          final username = currentUser?.username ?? "";
          final role = currentUser?.role ?? "";

          return _buildDetailCard(context, report, username, role);
        },
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    DailyProductionFractionationEntity report,
    String username,
    String role,
  ) {
    // Mengecek apakah tombol approve/reject harus dimunculkan
    final bool isActionable =
        report.checkedStatus != 'Approved' && report.checkedStatus != 'Rejected';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Kartu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Ticket: ${report.id}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(report.checkedStatus),
              ],
            ),
            const Divider(height: 24, thickness: 1.5),

            // --- General Information ---
            _buildDetailRow('Company', report.company ?? '-'),
            _buildDetailRow('Plant', report.plant ?? '-'),
            _buildDetailRow('Transaction Date', _formatDate(report.transactionDate)),
            _buildDetailRow('Posting Date', _formatDate(report.postingDate)),
            _buildDetailRow('Work Center', report.workCenter ?? '-'),
            _buildDetailRow('Shift', report.shift ?? '-'),

            // --- Raw Material (RM) ---
            _buildSectionHeader("Raw Material"),
            _buildDetailRow('Oil Type', report.oilTypeRmId ?? '-'),
            _buildDetailRow('From Tank', report.oilTypeRmFromTank?.toString() ?? '-'),
            _buildDetailRow(
              'Start Time',
              report.oilTypeRmAwalJam != null
                  ? "${report.oilTypeRmAwalJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeRmAwalJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('Start Flowmeter', report.oilTypeRmAwalFlowmeter?.toString() ?? '-'),
            _buildDetailRow(
              'End Time',
              report.oilTypeRmAkhirJam != null
                  ? "${report.oilTypeRmAkhirJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeRmAkhirJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('End Flowmeter', report.oilTypeRmAkhirFlowmeter?.toString() ?? '-'),
            _buildDetailRow('Total', report.oilTypeRmTotal?.toString() ?? '-'),

            // --- Finished Goods (FG) ---
            _buildSectionHeader("Finished Goods"),
            _buildDetailRow('Oil Type', report.oilTypeFgsId ?? '-'),
            _buildDetailRow(
              'Start Time',
              report.oilTypeFgsAwalJam != null
                  ? "${report.oilTypeFgsAwalJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeFgsAwalJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('Start Flowmeter', report.oilTypeFgsAwalFlowmeter?.toString() ?? '-'),
            _buildDetailRow(
              'End Time',
              report.oilTypeFgsAkhirJam != null
                  ? "${report.oilTypeFgsAkhirJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeFgsAkhirJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('End Flowmeter', report.oilTypeFgsAkhirFlowmeter?.toString() ?? '-'),
            _buildDetailRow('Total', report.oilTypeFgsTotal?.toString() ?? '-'),
            _buildDetailRow('To Tank', report.oilTypeFgsToTank ?? '-'),

            // --- By Product (BP) ---
            _buildSectionHeader("By Product"),
            _buildDetailRow(
              'Start Time',
              report.oilTypeFghAwalJam != null
                  ? "${report.oilTypeFghAwalJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeFghAwalJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('Start Flowmeter', report.oilTypeFghAwalFlowmeter?.toString() ?? '-'),
            _buildDetailRow(
              'End Time',
              report.oilTypeFghAkhirJam != null
                  ? "${report.oilTypeFghAkhirJam!.hour.toString().padLeft(2, '0')}:${report.oilTypeFghAkhirJam!.minute.toString().padLeft(2, '0')}"
                  : '-',
            ),
            _buildDetailRow('End Flowmeter', report.oilTypeFghAkhirFlowmeter?.toString() ?? '-'),
            _buildDetailRow('Total', report.oilTypeFghTotal?.toString() ?? '-'),
            _buildDetailRow('To Tank', report.oilTypeFghToTank ?? '-'),

            // --- Utility Usage ---
            _buildSectionHeader("Utility Usage"),
            _buildDetailRow('Item', report.uuItem ?? '-'),
            _buildDetailRow('Shift', report.shift ?? '-'),
            _buildDetailRow('Budget', report.uuBudgetRefQty ?? '-'),
            _buildDetailRow('Flowmeter Before', report.uuFlowmeterBefore?.toString() ?? '-'),
            _buildDetailRow('Flowmeter After', report.uuFlowmeterAfter?.toString() ?? '-'),
            _buildDetailRow('Flowmeter Total', report.uuFlowmeterTotal?.toString() ?? '-'),
            _buildDetailRow('Yield', report.uuYieldPercent?.toString() ?? '-'),
            _buildDetailRow('Listrik', report.uuListrik?.toString() ?? '-'),
            _buildDetailRow('Air', report.uuAir?.toString() ?? '-'),

            // --- Signatories & Status ---
            _buildSectionHeader("Approval Status"),
            _buildDetailRow('Input by', '${report.entryBy ?? '-'} on ${_formatDate(report.entryDate)}'),
            _buildDetailRow('Prepared by', '${report.preparedBy ?? '-'} on ${_formatDate(report.preparedDate)}'),
            _buildDetailRow('Prepared Remarks', report.preparedStatusRemarks ?? '-'),
            _buildDetailRow('Verified By', '${report.verifiedBy ?? '-'} on ${_formatDate(report.verifiedDate)}'),
            _buildDetailRow('Verified Status', report.verifiedStatus ?? '-'),
            _buildDetailRow('Checked by', '${report.checkedBy ?? '-'} on ${_formatDate(report.checkedDate)}'),
            _buildDetailRow('Checked Status', report.checkedStatus ?? '-'),
            _buildDetailRow('Checked Remarks', report.checkedStatusRemarks ?? '-'),

            // --- Form Info ---
            _buildSectionHeader("Form Info"),
            _buildDetailRow('Form No', report.formNo ?? '-'),
            _buildDetailRow('Date Issued', _formatDate(report.dateIssued)),
            _buildDetailRow('Revision No', report.revisionNo.toString()),

            // --- Action Buttons ---
            if (isActionable) ...[
              const SizedBox(height: 24),
              _buildApprovalButtonRow(context, report, username, role),
            ],
          ],
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildStatusChip(String? status) {
    Color chipColor;
    if (status == 'Approved') {
      chipColor = Colors.green;
    } else if (status == 'Rejected') {
      chipColor = Colors.red;
    } else {
      chipColor = Colors.grey;
      status = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status!,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(":"),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalButtonRow(
    BuildContext context,
    DailyProductionFractionationEntity report,
    String username,
    String role,
  ) {
    return Row(
      children: [
        // Reject Button
        Expanded(
          child: Consumer<DailyProductionFractionationProvider>(
            builder: (context, provider, child) => OutlinedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : () => _showRejectDialog(context, report, username, role),
              icon: const Icon(Icons.close),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Approve Button
        Expanded(
          child: Consumer<DailyProductionFractionationProvider>(
            builder: (context, provider, child) => ElevatedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : () => _handleAction(
                        context,
                        report,
                        username,
                        role,
                        'Approved',
                      ),
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              label: const Text('Approve'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Logic Helpers ---

  void _showRejectDialog(
    BuildContext context,
    DailyProductionFractionationEntity report,
    String username,
    String role,
  ) {
    _remarkController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Reject Report"),
        content: TextFormField(
          controller: _remarkController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: "Rejection Remark",
            hintText: "Please provide a reason for rejection.",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_remarkController.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext); // Tutup dialog
                _handleAction(
                  context,
                  report,
                  username,
                  role,
                  'Rejected',
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Remark cannot be empty!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Confirm Reject"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    DailyProductionFractionationEntity report,
    String username,
    String role,
    String status,
  ) async {
    final provider = context.read<DailyProductionFractionationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    try {
      final result = await provider.sendApproveRejectReport(
        username,
        status,
        role,
        report.shift ?? '',
        _remarkController.text.isEmpty ? null : _remarkController.text,
        plantCode,
        report.id,
        approveAllShift: false,
      );

      if (result && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ticket ${report.id} updated to $status.',
            ),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Memperbarui UI di halaman detail ini
        setState(() {
          report.checkedStatus = status;
        });

      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed: ${provider.errorMessage ?? "Unknown error"}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      log("Error handling action: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}