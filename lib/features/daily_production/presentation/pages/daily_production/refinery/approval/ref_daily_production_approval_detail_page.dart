import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryApprovalDetailPage extends StatefulWidget {
  const DailyProductionRefineryApprovalDetailPage({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });
  final List<DailyProductionRefineryEntity> reportEntities;
  final String reportIdentifier;

  @override
  State<DailyProductionRefineryApprovalDetailPage> createState() =>
      _DailyProductionRefineryApprovalDetailPageState();
}

class _DailyProductionRefineryApprovalDetailPageState
    extends State<DailyProductionRefineryApprovalDetailPage> {
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) =>
      date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';

  String _formatTime(TimeOfDay? time) =>
      time != null
          ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
          : '-';

  @override
  Widget build(BuildContext context) {
    // Urutkan berdasarkan waktu transaksi
    final sortedEntities = List<DailyProductionRefineryEntity>.from(
      widget.reportEntities,
    )..sort((a, b) {
      if (a.transactionDate == null) return 1;
      if (b.transactionDate == null) return -1;
      return a.transactionDate!.compareTo(b.transactionDate!);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${widget.reportIdentifier}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: sortedEntities.length,
        itemBuilder: (context, index) {
          final report = sortedEntities[index];

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
    DailyProductionRefineryEntity report,
    String username,
    String role,
  ) {
    final bool isActionable =
        report.checkedStatus != 'Approved' &&
        report.checkedStatus != 'Rejected';

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
            _buildDetailRow(
              'Transaction Date',
              _formatDate(report.transactionDate),
            ),
            _buildDetailRow('Posting Date', _formatDate(report.postingDate)),
            _buildDetailRow('Work Center', report.workCenter ?? '-'),
            _buildDetailRow('Shift', report.shift ?? '-'),

            // --- Raw Material (RM) ---
            _buildSectionHeader("Raw Material"),
            _buildDetailRow('Oil Type', report.oilTypeRm ?? '-'),
            _buildDetailRow('Start Time', _formatTime(report.oilTypeRmAwalJam)),
            _buildDetailRow(
              'Start Flowmeter',
              report.oilTypeRmAwalFlowmeter?.toString() ?? '-',
            ),
            _buildDetailRow('End Time', _formatTime(report.oilTypeRmAkhirJam)),
            _buildDetailRow(
              'End Flowmeter',
              report.oilTypeRmAkhirFlowmeter?.toString() ?? '-',
            ),
            _buildDetailRow('Total', report.oilTypeRmTotal?.toString() ?? '-'),

            // --- Finished Goods (FG) ---
            _buildSectionHeader("Finished Goods"),
            _buildDetailRow('Oil Type', report.oilTypeFg ?? '-'),
            _buildDetailRow('Start Time', _formatTime(report.oilTypeFgAwalJam)),
            _buildDetailRow(
              'Start Flowmeter',
              report.oilTypeFgAwalFlowmeter?.toString() ?? '-',
            ),
            _buildDetailRow('End Time', _formatTime(report.oilTypeFgAkhirJam)),
            _buildDetailRow(
              'End Flowmeter',
              report.oilTypeFgAkhirFlowmeter?.toString() ?? '-',
            ),
            _buildDetailRow('Total', report.oilTypeFgTotal?.toString() ?? '-'),
            _buildDetailRow('To Tank', report.oilTypeFgToTank ?? '-'),

            // --- Utility Usage ---
            _buildSectionHeader("Utility Usage"),
            _buildDetailRow('Item', report.uuItem ?? '-'),
            _buildDetailRow('Budget Ref Tank', report.uuBudgetRefTank ?? '-'),
            _buildDetailRow(
              'Budget Qty',
              report.uuBudgetQty?.toString() ?? '-',
            ),
            _buildDetailRow('Total', report.uuTotalCpo?.toString() ?? '-'),
            _buildDetailRow(
              'Total Steam',
              report.uuTotalSteam?.toString() ?? '-',
            ),
            _buildDetailRow('Steam/CPO', report.uuSteamCpo?.toString() ?? '-'),
            _buildDetailRow(
              'Yield (%)',
              report.uuYieldPercent != null
                  ? report.uuYieldPercent!.toStringAsFixed(2)
                  : '-',
            ),

            // --- Pemakaian Bahan Penolong ---
            _buildSectionHeader("Pemakaian Bahan Penolong"),
            _buildDetailRow(
              'Bleaching Earth Ref Tank',
              report.beRefTank ?? '-',
            ),
            _buildDetailRow('Bleaching Earth Qty', report.beRefQty ?? '-'),
            _buildDetailRow('Total Bag', report.beTotalBag ?? '-'),
            _buildDetailRow('Jenis', report.beTotalJenis ?? '-'),
            _buildDetailRow(
              'Lot/Batch Number',
              report.beLotBatchNumber?.toString() ?? '-',
            ),
            _buildDetailRow(
              'Yield (%)',
              report.beYieldPercent != null
                  ? report.beYieldPercent!.toStringAsFixed(2)
                  : '-',
            ),
            const Divider(),
            _buildDetailRow(
              'Phosphoric Acid Ref Tank',
              report.paRefTank ?? '-',
            ),
            _buildDetailRow('Phosphoric Acid Qty', report.paRefQty ?? '-'),
            _buildDetailRow('Total', report.paTotal ?? '-'),
            _buildDetailRow(
              'Lot/Batch Number',
              report.paLotBatchNumber?.toString() ?? '-',
            ),
            _buildDetailRow(
              'Yield (%)',
              report.paYieldPercent != null
                  ? report.paYieldPercent!.toStringAsFixed(2)
                  : '-',
            ),

            // --- Signatories & Status ---
            _buildSectionHeader("Approval Status"),
            _buildDetailRow(
              'Input by',
              '${report.entryBy ?? '-'} on ${_formatDate(report.entryDate)}',
            ),
            _buildDetailRow(
              'Prepared by',
              '${report.preparedBy ?? '-'} on ${_formatDate(report.preparedDate)}',
            ),
            _buildDetailRow('Prepared Status', report.preparedStatus ?? '-'),
            _buildDetailRow(
              'Prepared Remarks',
              report.preparedStatusRemarks ?? '-',
            ),
            _buildDetailRow(
              'Verified By',
              '${report.verifiedBy ?? '-'} on ${_formatDate(report.verifiedDate)}',
            ),
            _buildDetailRow('Verified Status', report.verifiedStatus ?? '-'),
            _buildDetailRow(
              'Checked by',
              '${report.checkedBy ?? '-'} on ${_formatDate(report.checkedDate)}',
            ),
            _buildDetailRow('Checked Status', report.checkedStatus ?? '-'),
            _buildDetailRow(
              'Checked Remarks',
              report.checkedStatusRemarks ?? '-',
            ),

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
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalButtonRow(
    BuildContext context,
    DailyProductionRefineryEntity report,
    String username,
    String role,
  ) {
    return Row(
      children: [
        // Reject Button
        Expanded(
          child: Consumer<DailyProductionRefineryProvider>(
            builder:
                (context, provider, child) => OutlinedButton.icon(
                  onPressed:
                      provider.isLoading
                          ? null
                          : () => _showRejectDialog(
                            context,
                            report,
                            username,
                            role,
                          ),
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
          child: Consumer<DailyProductionRefineryProvider>(
            builder:
                (context, provider, child) => ElevatedButton.icon(
                  onPressed:
                      provider.isLoading
                          ? null
                          : () => _handleAction(
                            context,
                            report,
                            username,
                            role,
                            'Approved',
                          ),
                  icon:
                      provider.isLoading
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
    BuildContext context, // Ini adalah context milik halaman (page)
    DailyProductionRefineryEntity report,
    String username,
    String role,
  ) {
    _remarkController.clear();
    showDialog(
      context: context,
      // Ubah nama parameter di sini menjadi dialogContext
      builder:
          (dialogContext) => AlertDialog(
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
                // Gunakan dialogContext untuk pop
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_remarkController.text.trim().isNotEmpty) {
                    // Gunakan dialogContext untuk menutup dialog
                    Navigator.pop(dialogContext);

                    // Tetap gunakan 'context' utama halaman untuk action
                    _handleAction(context, report, username, role, 'Rejected');
                  } else {
                    // Perhatikan: snackbar juga lebih baik menggunakan context halaman utama
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
    DailyProductionRefineryEntity report,
    String username,
    String role,
    String status,
  ) async {
    final provider = context.read<DailyProductionRefineryProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    final shiftNumber = int.tryParse(report.shift ?? '');
    if (shiftNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid shift number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final result = await provider.sendApproveRejectReport(
        username,
        status,
        role,
        shiftNumber.toString(),
        _remarkController.text.isEmpty ? null : _remarkController.text,
        report.id!,
        plantCode,
        approveAllShift: false,
      );

      if (result && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket ${report.id} updated to $status.'),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        // Memperbarui UI di halaman detail ini
        setState(() {
          report.checkedStatus = status;
        });
      } else if (mounted) {
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
      if (mounted) {
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
